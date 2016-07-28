open Areadppm
open Images

let files = ref [] 

let lowThresh = 10000000;;
let highThresh = 10000000;;
let med = (highThresh + lowThresh)/2;;
let edge = 16777215;;

let color_to_float (r,g,b) =
 (r *. 256. +. g) *. 256. +. b;
;;

let color_to_rgb c =
 let r = c / 65536 and g = c / 256 mod 256 and b = c mod 256 in
(r,g,b)
;;

  let read_ascii_24 c =
    (c.r * 256 + c.g) * 256 + c.b;
;;

let _ =
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id,  file1= match args with 
    | [id; file1] -> id,  file1
    | _ -> failwith "args error"
  in

  

let start = Unix.gettimeofday () in

  let img = load_ppm file1 in
  let height = img.Rgb24.height in
  let width = img.Rgb24.width  in
  
  (* let list = Str.split (Str.regexp "Non-max") file1 in
  let name, ext= match list with 
    | [name; ext] -> name, ext
    | _ -> failwith " error "
  in
     let sortie = name^"Hysteresis.ppm" in
*) 
	let sortie = "Sobel.ppm" in
   let oc = open_out sortie in 
  Printf.fprintf oc "P6\n" ;
  Printf.fprintf oc "%d %d \n"  (width-2) (height-2) ;
  Printf.fprintf oc "%d\n" 255;

let out = ref 0 in

for i=1 to height-2 do
    for j=1 to width-2 do

     let magnitude =  read_ascii_24 (Rgb24.get img j i) in
     
      if (magnitude >= highThresh) then
        out := edge
   else 
   begin 
   if (magnitude <= lowThresh) then
       out :=  0
    else  
    begin    
        if (magnitude >= med) then
            out := edge
        else
             out := 0
	end;
	end;
	match ( color_to_rgb !out) with 
      |(r, g, b)->
       output_byte oc r; output_byte oc g; output_byte oc b; 

    done;
  done;
  close_out oc; 


  let t1 = Unix.gettimeofday () in
  

  let oc = open_out "Erelation.txt" in
  Printf.fprintf oc "ID;TOTALTIME;ACTTIME;IMG1;\n";
  Printf.fprintf oc "%s;" id;
 (* Printf.fprintf oc "%F;" (t1 -. float_of_string(st));*)
  Printf.fprintf oc "%F;" (t1 -. start);
  Printf.fprintf oc "%s;" sortie;

  close_out oc;


