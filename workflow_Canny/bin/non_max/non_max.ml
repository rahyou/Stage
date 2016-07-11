#use  "readppm.ml";

open Spoc
open Images

    kernel non_max : Spoc.Vector.vint32-> Spoc.Vector.vint32 -> Spoc.Vector.vint32 -> int -> int -> unit = "kernels/non_max_kernel" "non_max"

let devices = Spoc.Devices.init ()

let dev = ref devices.(1)
let auto_transfers = ref false

let files = ref []
let color = ref 0 

let start = Unix.gettimeofday ()

let read_ascii_24 c =
  let r = c.r in
  let g = c.g in
  let b = c.b in
  (r * 256 + g) * 256 + b;
in




  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, st, file1, angle = match args with 
    | [id; st; file1; angle] -> id, st, file1, angle
    | _ -> failwith "args error"
  in


  (*let img = OImages.load file1 [] in                                          
    let w, h = OImages.size img in *)
  Spoc.Mem.auto_transfers !auto_transfers;
  Printf.printf "Will use device : %s\n" (!dev).Spoc.Devices.general_info.Spoc.Devices.name;

  Printf.printf "Will use simple precision\n"; 

  let img = load_ppm file1 in


  let theta = Spoc.Vector.create Vector.int32 (img.Rgb24.height * img.Rgb24.width)
  and a = Spoc.Vector.create Vector.int32 (img.Rgb24.height * img.Rgb24.width)
  and res = Spoc.Vector.create Vector.int32 (img.Rgb24.height * img.Rgb24.width )  in

  let fd = open_in angle in
  let _ = input_line fd in
  let rec aux i () = match input_line fd with
    | s -> Spoc.Mem.set theta i  (Int32.of_int (int_of_string (String.trim s))) ; aux (i+1) () 
    | exception End_of_file ->  Printf.printf "end of file"; 
    | exception Failure _ -> failwith "error"
  in aux 0 (); close_in fd; 




let non_max = non_max in  
let l = img.Rgb24.height in
let c = img.Rgb24.width  in
let f= ref 0 in
for i=0 to l-1 do  
  for j=0 to c-1 do
    let color = Rgb24.get img j i in
    Spoc.Mem.set a !f (Int32.of_int (read_ascii_24 color)) ;
    f := !f+1;
  done;
done;

Printf.printf "Fin\n";

if (not !auto_transfers) then
  begin
    Printf.printf "Transfering Values (on Device memory)\n";
    flush stdout;
    Spoc.Mem.to_device a !dev;
    Spoc.Mem.to_device theta !dev;
    Spoc.Mem.to_device res !dev;
  end;
begin     
  Printf.printf "Computing \n";
  flush stdout;

(*
    let threadsPerBlock = match !dev.Devices.specific_info with
      | Devices.OpenCLInfo clI ->
        (match clI.Devices.device_type with
         | Devices.CL_DEVICE_TYPE_CPU -> 1 (*si c'est un cpu device renvoie 1 sinon _ pour tous les autres cas renvoie 256*)
         | _ -> 32)
      | _ -> 32
    in
    let blocksPerGrid = (img.Rgb24.width*img.Rgb24.height + threadsPerBlock -1) / threadsPerBlock in
    let block = { Spoc.Kernel.blockX = threadsPerBlock; Spoc.Kernel.blockY = 1 ; Spoc.Kernel.blockZ = 1;} in
    let grid = { Spoc.Kernel.gridX = blocksPerGrid; Spoc.Kernel.gridY = 1 ; Spoc.Kernel.gridZ = 1;} in	
 *)   	 
  let threadsPerBlock = match !dev.Devices.specific_info with
    | Devices.OpenCLInfo clI -> 
      (match clI.Devices.device_type with
       | Devices.CL_DEVICE_TYPE_CPU -> 1
       | _  ->   16)
    | _  -> 16 in  
  let blocksPerGridy = (img.Rgb24.width + (threadsPerBlock) -1) / (threadsPerBlock) in
  let blocksPerGridx = (img.Rgb24.height + (threadsPerBlock) -1) / (threadsPerBlock) in


  let block = {Spoc.Kernel.blockX = threadsPerBlock; Spoc.Kernel.blockY = threadsPerBlock; Spoc.Kernel.blockZ = 1}
  and grid= {Spoc.Kernel.gridX = blocksPerGridx;   Spoc.Kernel.gridY = blocksPerGridy; Spoc.Kernel.gridZ = 1} in

  Printf.printf "compile \n";
  non_max#compile (~debug: true) !dev;
  Spoc.Kernel.run !dev (block, grid) non_max (a, res, theta, img.Rgb24.width, img.Rgb24.height);
  Pervasives.flush stdout;
end;	

if (not !auto_transfers) then
  begin
    Printf.printf "Transfering Vectors (on CPU memory)\n";
    Pervasives.flush stdout;
    Spoc.Mem.to_cpu res ();
  end;
Spoc.Devices.flush !dev ();
    
  let t1 = Unix.gettimeofday () in

  let list = Str.split (Str.regexp "Sobel") file1 in
  let name, ext= match list with 
    | [name; ext] -> name, ext
    | _ -> failwith " error "
  in
     let sortie = name^"Non-max.ppm" in

let ic1 = open_in file1 in
let oc1 = open_out sortie in 
let aa = input_line ic1 in
Printf.fprintf oc1 "%s\n" aa;
let b = input_line ic1 in
Printf.fprintf oc1 "%s\n" b ;
let c = input_line ic1 in
Printf.fprintf oc1 "%s \n" c;


for t = 0 to (Spoc.Vector.length res - 1) do
  let c =  Int32.to_int(Spoc.Mem.get res t)in
  let r = c / 65536  and  g = c / 256 mod 256  and  b = c mod 256  in
  output_byte oc1 r; output_byte oc1 g; output_byte oc1 b;
done;

close_out oc1;
close_in ic1;

let oc = open_out "Erelation.txt" in
begin
Printf.fprintf oc "ID;START;ACTTIME;IMG1\n";
Printf.fprintf oc "%s;" id;
Printf.fprintf oc "%s;" st;
Printf.fprintf oc "%F;" (t1 -. start);
Printf.fprintf oc "%s\n" sortie;
close_out oc;
end



