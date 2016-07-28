#use  "readppm.ml";
open Spoc
open Images

 kernel gauss_kernel : Spoc.Vector.vint32-> Spoc.Vector.vint32 -> int -> int -> unit = "kernels/gaussian_kernels" "gauss_kernel"

let devices = Spoc.Devices.init ()

let dev = ref devices.(1)
let auto_transfers = ref false
let verify = ref true
let files = ref []
let color = ref 0 

let start = Unix.time ()

let _ =
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, st, file1= match args with 
    | [id; st; file1] -> id, st, file1
    | _ -> failwith "args error"
  in

  let img = load_ppm file1 in

  let read_ascii_24 c =
    let r = c.r in
    let g = c.g in
    let b = c.b in
    (r * 256 + g) * 256 + b;
  in
  
  Spoc.Mem.auto_transfers !auto_transfers;
  Printf.printf "Will use device : %s\n" (!dev).Spoc.Devices.general_info.Spoc.Devices.name;
  Printf.printf "Will use simple precision\n"; 


  let  a = Spoc.Vector.create Vector.int32 (img.Rgb24.height * img.Rgb24.width) 
  and res = Spoc.Vector.create Vector.int32 (img.Rgb24.height * img.Rgb24.width )  in


  let gauss_kernel = gauss_kernel in  
  let height = img.Rgb24.height in
  let width = img.Rgb24.width  in
  let f= ref 0 in   
  for i=0 to height-1 do
    for j=0 to width-1 do
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
         | _ -> 16)
      | _ -> 16
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
    let blocksPerGridx = (height + (threadsPerBlock) -1) / (threadsPerBlock) in
    let blocksPerGridy = (width + (threadsPerBlock) -1) / (threadsPerBlock) in


    let block = {Spoc.Kernel.blockX = threadsPerBlock; Spoc.Kernel.blockY = threadsPerBlock; Spoc.Kernel.blockZ = 1}
    and grid= {Spoc.Kernel.gridX = blocksPerGridx;   Spoc.Kernel.gridY = blocksPerGridy; Spoc.Kernel.gridZ = 1} in


    Printf.printf "compile \n";
    gauss_kernel#compile (~debug: true) !dev;
    Spoc.Kernel.run !dev (block, grid) gauss_kernel (a, res, width, height);
    Pervasives.flush stdout;
  end;	
  
  (*calcul le transfert*)
   let sans_transfert2 = Unix.time () in
   
  if (not !auto_transfers) then
    begin
      Printf.printf "Transfering Vectors (on CPU memory)\n";
      Pervasives.flush stdout;
      Spoc.Mem.to_cpu res ();
    end;
  Spoc.Devices.flush !dev ();

    
  let t1 = Unix.time () in
    let list = Str.split (Str.regexp "Gray") file1 in
  let name, ext= match list with 
    | [name; ext] -> name, ext
    | _ -> failwith " error "
  in
     let sortie = name^"Gaussian.ppm" in


  let oc1 = open_out sortie in 
  Printf.fprintf oc1 "P6\n";
  Printf.fprintf oc1 "%d %d\n" height width ;
  Printf.fprintf oc1 "255 \n";


  for t = 0 to (Spoc.Vector.length res - 1) do
    let c =  Int32.to_int(Spoc.Mem.get res t)in
    let r = c / 65536  and  g = c / 256 mod 256  and  b = c mod 256  in
    output_byte oc1 r; output_byte oc1 g; output_byte oc1 b;
  done;
close_out oc1;
 
  let oc = open_out "Erelation.txt" in
  Printf.fprintf oc "ID;START;ACTTIME;IMG1\n";
    Printf.fprintf oc "%s;" id;
  Printf.fprintf oc "%s;" st;
  Printf.fprintf oc "%F;" (t1 -. start);
  Printf.fprintf oc "%s\n" sortie;
  close_out oc;

 let oc = open_out "Time.txt" in
  Printf.fprintf oc "sans transfert\n";
    Printf.fprintf oc "%F;" (sans_transfert2 -. start);
  Printf.fprintf oc "avec transfert\n";
  Printf.fprintf oc "%F;" (t1 -. start);
  close_out oc;

