open Areadppm
open Images

let files = ref [] 

let convolve_get_value img ukernel divisor offset = fun x y ->
  let sum_r = ref 0.0
  and sum_g = ref 0.0
  and sum_b = ref 0.0 in

  for i = -1 to 1 do
    for j = -1 to 1 do

      let c = Rgb24.get img (x+j) (y+i)  in  
      sum_r := !sum_r +. ukernel.(j+1).(i+1) *. (float c.r);
      sum_g := !sum_g +. ukernel.(j+1).(i+1) *. (float c.g);
      sum_b := !sum_b +. ukernel.(j+1).(i+1) *. (float c.b);
    done;
  done;
  ( !sum_r /. divisor +. offset,
    !sum_g /. divisor +. offset,
    !sum_b /. divisor +. offset )
    
    
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
  
let list = Str.split (Str.regexp "Gray") file1 in
  let name, ext= match list with 
    | [name; ext] -> name, ext
    | _ -> failwith " error "
  in
  let sortie = name^"Gaussian.ppm" in

  let oc = open_out sortie in 
  Printf.fprintf oc "P6\n" ;
  Printf.fprintf oc "%d %d \n"  (width-2) (height-2) ;
  Printf.fprintf oc "%d\n" 255;


 let ukernel = [|
    [| 0.; 1.; 0. |];
    [|  1.;  -3.;  1. |];
    [|  0.;  1.;  0. |];
  |] in

  
  for i=1 to height-2 do
    for j=1 to width-2 do

     let color = convolve_get_value img ukernel 1.0 0.0 j i in
      
      match (color) with 
      |(r, g, b)->
       output_byte oc (int_of_float(r)); output_byte oc (int_of_float(g));output_byte oc (int_of_float(b)); 

    done;
  done;
  close_out oc; 





  let t1 = Unix.gettimeofday () in
  
  let oc = open_out "Erelation.txt" in
  Printf.fprintf oc "ID;START;ACTTIME;IMG1\n";
  Printf.fprintf oc "%s;" id;
  Printf.fprintf oc "%s;" st;
  Printf.fprintf oc "%F;" (t1 -. start);
  Printf.fprintf oc "%s\n" sortie;
  close_out oc;
