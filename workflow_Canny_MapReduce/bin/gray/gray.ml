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
let color = ref 0 
let start = Unix.gettimeofday ()

let _ =
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, st, file1= match args with 
    | [id; st; file1] -> id, st, file1
    | _ -> failwith "args error "
  in


  let img = load_ppm file1 in

  let read_r c =
    let r = c.r in
    let _ = c.g in
    let _ = c.b in
    r;
  in
  let read_g c =
    let _ = c.r in
    let g = c.g in
    let _ = c.b in
    g;
  in
  let read_b c =
    let _ = c.r in
    let _ = c.g in
    let b = c.b in
    b;
  in

  let  a = Spoc.Vector.create Vector.int32 (img.Rgb24.height * img.Rgb24.width * 3)  in
  Printf.printf "Allocating Vectors (on CPU memory ) %d\n" (Spoc.Vector.length a - 1);
  flush stdout; 

  let l = img.Rgb24.height in
  let c = img.Rgb24.width  in
  let f= ref 0 in

  for i=0 to l-1 do  
    for j=0 to c-1 do
      let color = Rgb24.get img j i in
      a.[<!f>] <- (Int32.of_int (read_r color)) ;
      f := !f+1;
      a.[<!f>] <- (Int32.of_int (read_g color)) ;
      f := !f+1; 
      a.[<!f>] <- (Int32.of_int (read_b color)) ;
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
   
    let t1 = Unix.gettimeofday () in
    
  let list = Str.split (Str.regexp "part") file1 in
  let name, ext= match list with 
    | [name; ext] -> name, ext
    | _ -> failwith " error "
  in
     let sortie = name^"Gray.ppm" in


    let ic1 = open_in file1 in
    let oc1 = open_out sortie in 
    let z = input_line ic1 in
    Printf.fprintf oc1 "%s\n" z;
    let b = input_line ic1 in
    Printf.fprintf oc1 "%s\n" b ;
    let c = input_line ic1 in
    Printf.fprintf oc1 "%s\n" c;


    for i = 0 to Vector.length a - 1 do
      let c =  Int32.to_int  a.[<i>]  in
      output_byte oc1 c; 
    done;
    close_out oc1;
    close_in ic1;

 
  let oc = open_out "Erelation.txt" in
  Printf.fprintf oc "ID;START;ACTTIME;IMG1;\n";
  Printf.fprintf oc "%s;" id;
  Printf.fprintf oc "%s;" st;
  Printf.fprintf oc "%F;" (t1 -. start);
  Printf.fprintf oc "%s;" sortie;
  close_out oc;

  end;
