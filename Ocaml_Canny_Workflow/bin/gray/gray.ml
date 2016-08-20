#use  "readppm.ml";


let measure_time s f =
  let t0 = Unix.gettimeofday () in
  let a = f () in
  let t1 = Unix.gettimeofday () in
  Printf.printf "Time %s : %Fs\n%!" s (t1 -. t0);
  a;;

let files = ref []
let start = Unix.time () in



  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, file1= match args with 
    | [id; file1] -> id, file1
    | _ -> failwith "args error "
  in


     let curDir = Sys.getcwd () in
     let dir = List.nth (Str.split (Str.regexp "/bin/") curDir) 0 in
     let path = dir^"/Output/"^id in
     Unix.mkdir path 0o777;
     let sortie =  path^"/Gray.ppm" in
     
     
  let img = load_ppm file1 in

  let height = img.Rgb24.height in
  let width = img.Rgb24.width  in

 
    let oc = open_out sortie in 
	Printf.fprintf oc "P6\n" ;
    Printf.fprintf oc "%d %d \n"  width height ;
    Printf.fprintf oc "%d\n" 255;
 
  for i=0 to height-1 do  
    for j=0 to width-1 do
      let color = Rgb24.get img j i in

     let res = int_of_float ((0.21 *. (float (color.r))) +.
                            (0.71 *. (float (color.g))) +.
                            (0.07 *. (float (color.b))) ) in 
                            
    output_byte oc res; output_byte oc res; output_byte oc res; 

    done;
  done;
  close_out oc;
  

    Printf.printf "Fin\n";
    
  let t1 = Unix.time () in
   
   
   let oc = open_out "Erelation.txt" in
    Printf.fprintf oc "ID;START;ACTTIME;IMG1\n";
    Printf.fprintf oc "%s;" id;
    Printf.fprintf oc "%F;" start;
    Printf.fprintf oc "%F;" (t1 -. start);
    Printf.fprintf oc "%s\n" sortie;
    close_out oc;

