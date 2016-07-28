#use  "readppm.ml";
open Spoc
open Images

(* rmtree - remove whole directory trees like rm -r *)
#load "unix.cma";;

let rec finddepth f roots =
  Array.iter
    (fun root ->
       (match Unix.lstat root with
          | {Unix.st_kind=Unix.S_DIR} ->
              finddepth f
                (Array.map (Filename.concat root) (Sys.readdir root))
          | _ -> ());
       f root)
    roots

let zap path =
  match Unix.lstat path with
    | {Unix.st_kind=Unix.S_DIR} ->
        Printf.printf "rmdir %s\n%!" path;
        Unix.rmdir path
    | _ ->
        Printf.printf "unlink %s\n%!" path;
        Unix.unlink path


 (* finddepth zap (Array.sub Sys.argv 1 (Array.length Sys.argv - 1))*)



let measure_time s f =
  let t0 = Unix.gettimeofday () in
  let a = f () in
  let t1 = Unix.gettimeofday () in
  Printf.printf "Time %s : %Fs\n%!" s (t1 -. t0);
  a;;

let start = Unix.gettimeofday () 
let files = ref []


let _ =
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, file1= match args with 
    | [id; file1] -> id, file1
    | _ -> failwith "args error"
  in


  let img = load_ppm file1 in
  
let read_ascii_24 c =
    let r = c.r in
    let g = c.g in
    let b = c.b in
    (*float_of_int *)(r * 256 + g) * 256 + b;
  in


 let curDir = Sys.getcwd () in
     let dir = List.nth (Str.split (Str.regexp "/bin/") curDir) 0 in
		let path = dir^"/Output/"^id in
     (*if (Sys.file_exists path) then
		finddepth zap path*)
		
 Unix.mkdir path 0o777;		
 Unix.mkdir  (path^"/1/") 0o777;
 Unix.mkdir  (path^"/2/") 0o777;
 Unix.mkdir  (path^"/3/") 0o777;
 Unix.mkdir  (path^"/4/") 0o777;
 
  let oc1 = open_out (path^"/1/parte1.ppm") in
  let oc2 = open_out (path^"/2/parte2.ppm") in
  let oc3 = open_out (path^"/3/parte3.ppm") in
  let oc4 = open_out (path^"/4/parte4.ppm") in

  let cols = (img.Rgb24.width /2) in
  let lins = (img.Rgb24.height /2) in
  
     let ic1 = open_in file1 in
    let z = input_line ic1 in
    Printf.fprintf oc1 "%s\n" z;
        Printf.fprintf oc2 "%s\n" z;
            Printf.fprintf oc3 "%s\n" z;
                Printf.fprintf oc4 "%s\n" z;
                
    let _ = input_line ic1 in
    Printf.fprintf oc1 "%d %d\n" cols lins;
    Printf.fprintf oc2 "%d %d\n" cols lins;
    Printf.fprintf oc3 "%d %d\n" cols lins;
    Printf.fprintf oc4 "%d %d\n" cols lins; 
    
    let c = input_line ic1 in
    Printf.fprintf oc1 "%s\n" c;
    Printf.fprintf oc2 "%s\n" c;
  	Printf.fprintf oc3 "%s\n" c;
  	Printf.fprintf oc4 "%s\n" c;
  	  
 for p=0 to 3 do 	  
 for i=0 to lins -1 do
   for j=0 to cols-1 do
     		
    if p = 0 then 
    begin   
    let color = Rgb24.get img (j) (i) in
     let c = read_ascii_24 color in
     let r = c / 65536  and  g = c / 256 mod 256  and  b = c mod 256  in
     output_byte oc1 r; output_byte oc1 g; output_byte oc1 b;
     end;

	if p = 1 then 
	 begin
	 let color = Rgb24.get img (j) ( lins + i ) in
     let c = read_ascii_24 color in
     let r = c / 65536  and  g = c / 256 mod 256  and  b = c mod 256  in
	 output_byte oc2 r; output_byte oc2 g; output_byte oc2 b;
	    end;
	if p = 2 then 
	    begin
	      let color = Rgb24.get img (cols + j) ( i ) in
     let c = read_ascii_24 color in
     let r = c / 65536  and  g = c / 256 mod 256  and  b = c mod 256  in
	 output_byte oc3 r; output_byte oc3 g; output_byte oc3 b;
    end;
	if p = 3 then 
	    begin
	      let color = Rgb24.get img (cols + j) ( lins  + i ) in
     let c = read_ascii_24 color in
     let r = c / 65536  and  g = c / 256 mod 256  and  b = c mod 256  in
	output_byte oc4 r; output_byte oc4 g; output_byte oc4 b;
     end;
     done;

     done;

     done;
     close_out oc1;
     close_out oc2;
     close_out oc3;
     close_out oc4;
     
     let t1 = Unix.gettimeofday () in
  begin     
 
  
   let oc = open_out "Erelation.txt" in
    Printf.fprintf oc "ID;START;ACTTIME;IMG1\n"(*;IMG2\n*);
    Printf.fprintf oc "%d;" (int_of_string(id));
 Printf.fprintf oc "%F;" start;
    Printf.fprintf oc "%F;" (t1 -. start);
    Printf.fprintf oc "%s/1/parte1.ppm\n" path ;
    
        Printf.fprintf oc "%d;" (int_of_string(id));
 Printf.fprintf oc "%F;" start;
    Printf.fprintf oc "%F;" (t1 -. start);
    Printf.fprintf oc "%s/2/parte2.ppm\n" path;
    
        Printf.fprintf oc "%d;" (int_of_string(id));
 Printf.fprintf oc "%F;" start;
    Printf.fprintf oc "%F;" (t1 -. start);
    Printf.fprintf oc "%s/3/parte3.ppm\n" path;
    
        Printf.fprintf oc "%d;" (int_of_string(id));
 Printf.fprintf oc "%F;" start;
    Printf.fprintf oc "%F;" (t1 -. start);
    Printf.fprintf oc "%s/4/parte4.ppm\n" path;
  
    close_out oc;

 
  end;
