#use  "readppm.ml";

open Spoc
open Images

    kernel sobel_kernel : Spoc.Vector.vfloat32-> Spoc.Vector.vfloat32 -> Spoc.Vector.vfloat32 -> int -> int -> unit = "kernels/sobel_kernel" "sobel_kernel"

let devices = Spoc.Devices.init ()

let dev = ref devices.(1)
let auto_transfers = ref false

let files = ref []
let color = ref 0 




let _ =
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, file1= match args with 
    | [id; file1] -> id, file1
    | _ -> failwith "args error"
  in

  (*let img = OImages.load file1 [] in                                          
    let w, h = OImages.size img in *)
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


  let  a = Spoc.Vector.create Vector.float32 (img.Rgb24.height * img.Rgb24.width)
  and  theta = Spoc.Vector.create Vector.float32 (img.Rgb24.height * img.Rgb24.width) 
  and res = Spoc.Vector.create Vector.float32 (img.Rgb24.height * img.Rgb24.width )  in


  let sobel_kernel = sobel_kernel in  
  let l = img.Rgb24.height in
  let c = img.Rgb24.width  in
  let f= ref 0 in
  for i=0 to l-1 do 
    for j=0 to c-1 do

      let color = Rgb24.get img j i in
      Spoc.Mem.set a !f (float_of_int(read_ascii_24 color)) ;
      Spoc.Mem.set theta !f 90.0; 
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
    let blocksPerGridx = (img.Rgb24.height + (threadsPerBlock) -1) / (threadsPerBlock) in
    let blocksPerGridy = (img.Rgb24.width + (threadsPerBlock) -1) / (threadsPerBlock) in


    let block = {Spoc.Kernel.blockX = threadsPerBlock; Spoc.Kernel.blockY = threadsPerBlock; Spoc.Kernel.blockZ = 1}
    and grid= {Spoc.Kernel.gridX = blocksPerGridx;   Spoc.Kernel.gridY = blocksPerGridy; Spoc.Kernel.gridZ = 1} in

    Printf.printf "compile \n";
    sobel_kernel#compile (~debug: true) !dev;
    Spoc.Kernel.run !dev (block, grid) sobel_kernel (a, res, theta, img.Rgb24.width, img.Rgb24.height);
    Pervasives.flush stdout;
  end;	

  if (not !auto_transfers) then
    begin
      Printf.printf "Transfering Vectors (on CPU memory)\n";
      Pervasives.flush stdout;
      Spoc.Mem.to_cpu res ();
      Spoc.Mem.to_cpu theta ();
    end;
  Spoc.Devices.flush !dev ();

 (*let sortie = "/home/racha/Documents/stage/workflow_Canny/Output/"file1^"_2.ppm" in*)
  let sortie = "/home/racha/Documents/stage/workflow_Canny_Reduce/Output/output_2.ppm" in

  let ic1 = open_in file1 in
  let oc1 = open_out sortie in 
  let aa = input_line ic1 in
  Printf.fprintf oc1 "%s\n" aa;
  let b = input_line ic1 in
  Printf.fprintf oc1 "%s\n" b ;
  let c = input_line ic1 in
  Printf.fprintf oc1 "%s \n" c;

  for t = 0 to (Spoc.Vector.length res - 1) do
    let c =  Spoc.Mem.get res t in
    let r = int_of_float c / 65536  and  g = int_of_float c / 256 mod 256  and  b = int_of_float c mod 256  in
    output_byte oc1 r; output_byte oc1 g; output_byte oc1 b;
  done;

  close_out oc1;
  close_in ic1;


  let angle = "/home/racha/Documents/stage/workflow_Canny/Output/theta.csv" in
  let oc = open_out angle in
  Printf.fprintf oc "theta\n";
  for t = 0 to (Spoc.Vector.length theta - 1) do
    let c =  int_of_float(Spoc.Mem.get theta t)in
    Printf.fprintf oc "%d\n" c;
  done;

  let oc = open_out "Erelation.txt" in
  Printf.fprintf oc "ID;IMG1;ANGLE\n";
  Printf.fprintf oc "%s;" id;
  Printf.fprintf oc "%s;" sortie;
  Printf.fprintf oc "%s\n" angle ;
  close_out oc;



