open Areadppm
open Images

let files = ref []
 let pi = 4.0 *. atan 1.0;;
 
 
  let read_ascii_24 c =
    (c.r * 256 + c.g) * 256 + c.b;
;;


let convolve_get_value img ukernel divisor offset = fun x y ->
  let sum_c = ref 0.0 in

  for i = -1 to 1 do
    for j = -1 to 1 do

      let c = read_ascii_24 (Rgb24.get img (x+j) (y+i))  in  
      sum_c := !sum_c +. ukernel.(j+1).(i+1) *. (float c);

    done;
  done;
  ( !sum_c /. divisor +. offset)
    ;;
   

let color_to_rgb c =
 let r = c / 65536 and g = c / 256 mod 256 and b = c mod 256 in
(r,g,b)
;;

 
let color_to_float (r,g,b) =
 (r *. 256. +. g) *. 256. +. b;
;;

let get_theta colorx colory =
  let theta = ref 0 in
let angle = ref 0.0 in


angle := atan2 colory colorx;

if (!angle < 0.)  then	
	angle := mod_float (!angle +.( 2. *. pi)) (2. *. pi);

theta :=  (int_of_float (57.29577951 *. (!angle *. (pi /. 8.) +. (pi /. 8.) -. 0.0001) /. 45.) * 45) mod 180 ;
  (!theta)
;;

   
let _ =
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, st, file1= match args with 
    | [id; st; file1] -> id, st, file1
    | _ -> failwith "args error"
 in

 
let start = Unix.gettimeofday () in

  let img = load_ppm file1 in
  let height = img.Rgb24.height in
  let width = img.Rgb24.width  in
  
  let list = Str.split (Str.regexp "Gaussian") file1 in
  let name, ext= match list with 
    | [name; ext] -> name, ext
    | _ -> failwith " error "
  in
     let sortie = name^"Sobel.ppm" in
  let angle = name^"theta.csv" in
  let oangle = open_out angle in
  Printf.fprintf oangle "theta\n";
  
 
  
  let oc = open_out sortie in 
  Printf.fprintf oc "P6\n" ;
  Printf.fprintf oc "%d %d \n"  (width-2) (height-2) ;
  Printf.fprintf oc "%d\n" 255;


let kernely = [|
    [| -1.; 0.; 1. |];
    [|  -2.;  0.; 2. |];
    [|  -1.;  0.; 1. |];
  |] in
  

let kernelx = [|
    [| -1.; -2.; -1. |];
    [|  0.; 0.;  0. |];
    [|  1.; 2.; 1. |];
  |] in
  

let max_value = ref 0 in

for i=1 to height-2 do
    for j=1 to width-2 do
 
   let color =  read_ascii_24 ( Rgb24.get img j i) in
   max_value := if color > !max_value then color else !max_value;
	
	let colorx = convolve_get_value img kernelx 1.0 0.0 j i in
   let  colory = convolve_get_value img kernely 1.0 0.0 j i in 
     
  
	let hy = hypot colorx  colory  in
	 let hyp = if ( hy >= float_of_int(!max_value )) then hy else 0.0 in 

	let hypr, hypg, hypb = color_to_rgb (int_of_float hyp) in
	output_byte oc  hypr; output_byte oc  hypg; output_byte oc hypb; 
	
	let angle = get_theta colorx colory in
	Printf.fprintf oangle "%d\n"  angle ;
   
    done;
  done;
  close_out oc; 
close_out oangle;
   


  let t1 = Unix.gettimeofday () in
  
 
  let oc = open_out "Erelation.txt" in
  Printf.fprintf oc "ID;START;ACTTIME;IMG1;ANGLE\n";
  Printf.fprintf oc "%s;" id;
  Printf.fprintf oc "%s;" st;
  Printf.fprintf oc "%F;" (t1 -. start);
  Printf.fprintf oc "%s;" sortie;
  Printf.fprintf oc "%s\n" angle ;
  close_out oc;
