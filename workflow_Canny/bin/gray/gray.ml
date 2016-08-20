#use  "readppm.ml";
open Spoc
open Images
open Kirc

let devices = Spoc.Devices.init ()

open Kirc

let gpu_to_gray = kern v w h->
  let open Std in
  let tid = thread_idx_x + block_dim_x * block_idx_x in
  if tid <= (w*h) then (
    let i = (tid*3) in
    let res = int_of_float ((0.21 *. (float (v.[<i>]))) +.
                            (0.71 *. (float (v.[<i+1>]))) +.
                            (0.07 *. (float (v.[<i+2>]))) ) in
    v.[<i>] <- res;
    v.[<i+1>] <- res;
    v.[<i+2>] <- res )


let measure_time s f =
  let t0 = Unix.gettimeofday () in
  let a = f () in
  let t1 = Unix.gettimeofday () in
  Printf.printf "Time %s : %Fs\n%!" s (t1 -. t0);
  a;;

let dev = ref devices.(1)
let auto_transfers = ref false
let verify = ref true
let files = ref []

let start = Unix.time ()


let _=
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, file1= match args with 
    | [id; file1] -> id, file1
    | _ -> failwith "args error "
  in


  let img = load_ppm file1 in

 

  let  a = Spoc.Vector.create Vector.int32 (img.Rgb24.height * img.Rgb24.width * 3)  in
  Printf.printf "Allocating Vectors (on CPU memory ) %d\n" (Spoc.Vector.length a - 1);
  flush stdout; 

  let height = img.Rgb24.height in
  let width = img.Rgb24.width  in
  let f= ref 0 in

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

  begin     
    Printf.printf "Computing \n";
    flush stdout;


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
             gpu_to_gray);
    measure_time "" 
      (fun () -> Kirc.run gpu_to_gray (a, img.Rgb24.height , img.Rgb24.width) (block,grid) 0 !dev);


    Printf.printf "Fin\n";
    
  let t1 = Unix.time () in
   
     let curDir = Sys.getcwd () in
     let dir = List.nth (Str.split (Str.regexp "/bin/") curDir) 0 in
     let path = dir^"/Output/"^id in
     Unix.mkdir path 0o777;
     let sortie =  path^"/Gray.ppm" in
   
       let oc = open_out sortie in 
	Printf.fprintf oc "P6\n" ;
    Printf.fprintf oc "%d %d \n"  width height ;
    Printf.fprintf oc "%d\n" 255;

    for i = 0 to Vector.length a - 1 do
      let c =  Int32.to_int  a.[<i>]  in
      output_byte oc c; 
    done;
    close_out oc;

  
   let oc = open_out "Erelation.txt" in
    Printf.fprintf oc "ID;START;ACTTIME;IMG1\n";
    Printf.fprintf oc "%s;" id;
    Printf.fprintf oc "%F;" start;
    Printf.fprintf oc "%F;" (t1 -. start);
    Printf.fprintf oc "%s\n" sortie;
    close_out oc;

 
  end;
