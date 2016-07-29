open Areadppm
open Images

let files = ref []

let pi = 4.0 *. atan 1.0;;
let edge = 16777215;;



let color_to_rgb c =
  let r = c / 65536 and g = c / 256 mod 256 and b = c mod 256 in
  (r,g,b)
;;
let read_ascii_24 c =
  (c.r * 256 + c.g) * 256 + c.b;
;;

let color_to_float (r,g,b) =
  (r *. 256. +. g) *. 256. +. b;
;;

  let non_max_get_value img theta = fun x y ->
  
let color =  read_ascii_24 (Rgb24.get img x y) in
  
  (*  let out= ref 0 in
*)
   let out = match theta with

    | 0 -> if (color >= (read_ascii_24 (Rgb24.get img (x) (y+1))) &&
               (color >= (read_ascii_24 (Rgb24.get img (x) (y-1))))) then
         color
      else 
        0

    | 45 -> if (color >= (read_ascii_24(Rgb24.get img (x-1) (y+1)))&&
                (color >= (read_ascii_24(Rgb24.get img (x+1) (y-1))))) then
        color
      else 
        0

    | 90 -> if (color >= (read_ascii_24(Rgb24.get img (x-1) (y))) &&
                (color >= (read_ascii_24(Rgb24.get img (x+1) (y))))) then
         color
      else 
         0

    | 135 -> if (color >= (read_ascii_24(Rgb24.get img (x-1) (y-1))) &&
                 (color >= (read_ascii_24(Rgb24.get img (x+1) (y+1))))) then
       color
      else 
         0
    | _ -> failwith "args error"
  in
   (out)
;;

let _ =
Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
Random.self_init();
let args = List.rev !files in
let id, st, file1, angle = match args with 
  | [id;  st; file1; angle] -> id, st, file1, angle
  | _ -> failwith "args error"
in

let start = Unix.gettimeofday () in

let img = load_ppm file1 in
let height = img.Rgb24.height in
let width = img.Rgb24.width  in

let matrice = Array.make ((width * height)-1) (0) in 
  

 let fd = open_in angle in
  let _ = input_line fd in
  let rec aux i () = match input_line fd with
  
    | s -> if ( i <> ((width * height)-1)) then 
    begin
		matrice.(i) <- (int_of_string (String.trim s)) ;  aux (i+1) ()
		end 
    | exception End_of_file ->  Printf.printf "end of file"; 
    | exception Failure _ -> failwith "error"
  in aux 0 (); close_in fd; 


let list = Str.split (Str.regexp "Sobel") file1 in
let name, ext= match list with 
  | [name; ext] -> name, ext
  | _ -> failwith " error "
in
let sortie = name^"Non-max.ppm" in

let oc = open_out sortie in 
Printf.fprintf oc "P6\n" ;
Printf.fprintf oc "%d %d \n"  (width-2) (height-2) ;
Printf.fprintf oc "%d\n" 255;

  let f= ref 0 in
for i=1 to height-2 do
  for j=1 to width-2 do

   let theta =  matrice.(!f) in
   
  let color = non_max_get_value img theta j i in
  
  match ( color_to_rgb color) with 
      |(r, g, b)->
       output_byte oc r; output_byte oc g; output_byte oc b; 
  
   f := !f+1;
 done;
done;
  close_out oc; 

let t1 = Unix.gettimeofday () in

let oc = open_out "Erelation.txt" in
begin
  Printf.fprintf oc "ID;START;ACTTIME;IMG1\n";
  Printf.fprintf oc "%s;" id;
Printf.fprintf oc "%s;" st;
  Printf.fprintf oc "%F;" (t1 -. start);
  Printf.fprintf oc "%s\n" sortie;
  close_out oc;
end



