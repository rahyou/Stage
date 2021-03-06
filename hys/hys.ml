#use  "areadppm.ml";
open Spoc
open Images
open Kirc


let read_ascii_24 c =
  (c.r * 256 + c.g) * 256 + c.b;
;;

let color_to_rgb c =
  let r = c / 65536 and g = c / 256 mod 256 and b = c mod 256 in
  (r,g,b)
;;

(*allouer Tresh avant sur le GPU!*)
let devices = Spoc.Devices.init ()

let gpu_hys  = kern v w h->
  let lowThresh = 170 in
  let highThresh = 90 in
  let med = (highThresh + lowThresh)/2 in
  let edge = 16777215 in
  let open Std in
  let tid = thread_idx_x + block_dim_x * block_idx_x in
  if tid <= (w*h) then (
    let i = (tid*3) in

    let magnitude = (((v.[<i>] * 256 ) + (v.[<i+1>])) * 256 + (v.[<i+2>])) in
    if (magnitude >= med)  then

      let r = edge / 65536 in
      let g = edge / 256 mod 256 in
      let b = edge mod 256 in

      v.[<i>] <- r;
      v.[<i+1>] <- g;
      v.[<i+2>] <- b 

    else 
    v.[<i>] <- 0;
    v.[<i+1>] <-0;
    v.[<i+2>] <-0 )                      

let measure_time s f =
  let t0 = Unix.gettimeofday () in
  let a = f () in
  let t1 = Unix.gettimeofday () in
  Printf.printf "Time %s : %Fs\n%!" s (t1 -. t0);
  a;;


let dev = ref devices.(1)
let auto_transfers = ref false
let verify = ref true

let start = Unix.time ()

let files = ref [] in 
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id,   file1= match args with 
    | [id;  file1] -> id,   file1
    | _ -> failwith "args error"
  in


  let img = load_ppm file1 in
  let height = img.Rgb24.height in
  let width = img.Rgb24.width  in


  let  a = Spoc.Vector.create Vector.int32 (img.Rgb24.height * img.Rgb24.width * 3)  in
  Printf.printf "Allocating Vector (on CPU memory ) %d\n" (Spoc.Vector.length a - 1);
  flush stdout; 

  let f = ref 0 in
  for i=0 to height-1 do
    for j=0 to width-1 do
      let color = Rgb24.get img j i in    
      a.[<!f>] <- (Int32.of_int (color.r)) ;
      f := !f+1;
      a.[<!f>] <- (Int32.of_int (color.g)) ;
      f := !f+1; 
      a.[<!f>] <- (Int32.of_int (color.b)) ;
      f := !f+1;
    done;
  done;

  let threadsPerBlock = match !dev.Devices.specific_info with
    | Devices.OpenCLInfo clI -> 
      (match clI.Devices.device_type with
       | Devices.CL_DEVICE_TYPE_CPU -> 1
       | _  ->   256)
    | _  -> 256 in
  let blocksPerGrid =
    ((img.Rgb24.height * img.Rgb24.width) + threadsPerBlock -1) / threadsPerBlock
  in
  let block = { Spoc.Kernel.blockX = threadsPerBlock; Spoc.Kernel.blockY = 1 ; Spoc.Kernel.blockZ = 1;} in
  let grid = { Spoc.Kernel.gridX = blocksPerGrid; Spoc.Kernel.gridY = 1 ; Spoc.Kernel.gridZ = 1;} in	

  ignore(Kirc.gen ~only:Devices.OpenCL
           gpu_hys);
  measure_time "" 
    (fun () -> Kirc.run gpu_hys (a, img.Rgb24.height , img.Rgb24.width) (block,grid) 0 !dev);


  Printf.printf "Fin\n";


  let t1 = Unix.time () in

 (* let list = Str.split (Str.regexp "Non-max") file1 in
     let name, ext= match list with 
     | [name; ext] -> name, ext
     | _ -> failwith " error "
     in
     let sortie = name^"Hysteresis.ppm" in
  *)
      let sortie = "Hysteresis.ppm" in
  let oc = open_out sortie in 
  Printf.fprintf oc "P6\n" ;
  Printf.fprintf oc "%d %d \n"  (width) (height) ;
  Printf.fprintf oc "%d\n" 255;


  for i = 0 to Vector.length a - 1 do
    let c =  Int32.to_int  a.[<i>]  in
    output_byte oc c; 
  done;
  close_out oc;

  let oc = open_out "Erelation.txt" in
  Printf.fprintf oc "ID;TOTALTIME;ACTTIME;IMG1;\n";
  Printf.fprintf oc "%s;" id;
  (* Printf.fprintf oc "%F;" (t1 -. float_of_string(st));*)
  Printf.fprintf oc "%F;" (t1 -. start);
  Printf.fprintf oc "%s;" sortie;

  close_out oc;


