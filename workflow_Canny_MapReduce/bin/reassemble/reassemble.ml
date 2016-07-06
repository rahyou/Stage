open Readppm

open Images

let devices = Spoc.Devices.init ()

let measure_time s f =
  let t0 = Unix.gettimeofday () in
  let a = f () in
  let t1 = Unix.gettimeofday () in
  Printf.printf "Time %s : %Fs\n%!" s (t1 -. t0);
  a;;

let verify = ref true
let files = ref []
let color = ref 0 

let _ =
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let file1 = match args with 
    | [file1] -> file1
    | _ -> failwith "args error  "
  in

 let file= file1^".hfrag" in
 
(*pour chq ID on fait la liste ordonné des parties  *)
(*
pour chq id on rassemble la liste dans un seul image
*)


let read_ascii_24 c =
    let r = c.r in
    let g = c.g in
    let b = c.b in
    (*float_of_int *)(r * 256 + g) * 256 + b;
  in
  

  let fd = open_in file in  
   let line = input_line fd in
  let line = input_line fd in
  let list = Str.split (Str.regexp ";") line in
  let id, file1= match list with 
    | [id; file1] -> id, file1
    | _ -> failwith " error "
  in
  
   let line = input_line fd in
  let list = Str.split (Str.regexp ";") line in
  let id, file2= match list with 
    | [id; file2] -> id, file2
    | _ -> failwith "%s" list
  in
  
   let line = input_line fd in
  let list = Str.split (Str.regexp ";") line in
  let id, file3= match list with 
    | [id; file3] -> id, file3
    | _ -> failwith " error "
  in
  
   let line = input_line fd in
  let list = Str.split (Str.regexp ";") line in
  let id, file4= match list with 
    | [id; file4] -> id, file4
    | _ -> failwith " error "
  in
  
  
  
let img1 = load_ppm file1 in
let img2 = load_ppm file2 in
let img3 = load_ppm file3 in
let img4 = load_ppm file4 in

  let l = img1.Rgb24.height in
  let c = img1.Rgb24.width  in
 
  let ch = "/home/racha/Documents/stage/workflow_Canny_MapReduce/Output/"^id^"/image.ppm" in 
  let oc = open_out ch in
  
    let ic1 = open_in file1 in
    let z = input_line ic1 in
    Printf.fprintf oc "%s\n" z;
                  
   let b = input_line ic1 in
    Printf.fprintf oc "%d %d\n" (c*2) (l*2 );
    
    let w = input_line ic1 in
    Printf.fprintf oc "%s\n" w;

 for i=0 to l-1 do  
    for j=0 to c-1 do
      let co = Rgb24.get img1 j i in
      let color = read_ascii_24 co in
      let r = color / 65536  and  g = color / 256 mod 256  and  b = color mod 256  in
	  output_byte oc r; output_byte oc g; output_byte oc b;
    done;
    for j=0 to c-1 do
      let co = Rgb24.get img3 j i in
      let color = read_ascii_24 co in
      let r = color / 65536  and  g = color / 256 mod 256  and  b = color mod 256  in
	  output_byte oc r; output_byte oc g; output_byte oc b;
    done;
  done;
  for i=0 to l-1 do  
   for j=0 to c-1 do
      let co = Rgb24.get img2 j i in
      let color = read_ascii_24 co in
      let r = color / 65536  and  g = color / 256 mod 256  and  b = color mod 256  in
	   output_byte oc r; output_byte oc g; output_byte oc b;
    done;
    
     for j=0 to c-1 do
      let co = Rgb24.get img4 j i in
      let color = read_ascii_24 co in
      let r = color / 65536  and  g = color / 256 mod 256  and  b = color mod 256  in
	  output_byte oc r; output_byte oc g; output_byte oc b;
    done;
  done;
close_out oc;
   
let oc = open_out "Erelation.txt" in
    Printf.fprintf oc "ID;IMG1\n";
    Printf.fprintf oc "%d;" (int_of_string(id));

    Printf.fprintf oc "/home/racha/Documents/stage/workflow_Canny_MapReduce/Output/%s/image.ppm\n" id ;
      
    close_out oc;

 
