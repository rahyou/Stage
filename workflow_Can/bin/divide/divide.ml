open Spoc
open Images
open Kirc
open Readppm

let devices = Spoc.Devices.init ()

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

let _ =
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, file1= match args with 
    | [id; file1] -> id, file1
    | _ -> failwith "args error        "
  in


  let img = load_ppm file1 in
  
let read_ascii_24 c =
    let r = c.r in
    let g = c.g in
    let b = c.b in
    (*float_of_int *)(r * 256 + g) * 256 + b;
  in
  
  
  let oc1 = open_out "/home/racha/Documents/stage/workflow_Can/Output/part1.ppm" in
  let oc2 = open_out "/home/racha/Documents/stage/workflow_Can/Output/part2.ppm" in
  let oc3 = open_out "/home/racha/Documents/stage/workflow_Can/Output/part3.ppm" in
  let oc4 = open_out "/home/racha/Documents/stage/workflow_Can/Output/part4.ppm" in

  let cols = img.Rgb24.width /2 in
  let lins = img.Rgb24.height /2 in
  
     let ic1 = open_in file1 in
    let z = input_line ic1 in
    Printf.fprintf oc1 "%s\n" z;
        Printf.fprintf oc2 "%s\n" z;
            Printf.fprintf oc3 "%s\n" z;
                Printf.fprintf oc4 "%s\n" z;
                
    let b = input_line ic1 in
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
    
    let color = Rgb24.get img ( j) (  i ) in
     let c = read_ascii_24 color in
     let r = c / 65536  and  g = c / 256 mod 256  and  b = c mod 256  in
     output_byte oc1 r; output_byte oc1 g; output_byte oc1 b;
     end;
	if p = 1 then 
	
	    begin
	      let color = Rgb24.get img ( j) ( lins + i ) in
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
	      let color = Rgb24.get img (cols  + j) ( lins  + i ) in
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
     
  begin     
 
  
   let oc = open_out "Erelation.txt" in
    Printf.fprintf oc "ID;IMG1\n"(*;IMG2\n*);
    Printf.fprintf oc "%d;" (int_of_string(id));
    Printf.fprintf oc "/home/racha/Documents/stage/workflow_Can/Output/part1.ppm\n";
        Printf.fprintf oc "%d;" (int_of_string(id));
    Printf.fprintf oc "/home/racha/Documents/stage/workflow_Can/Output/part2.ppm\n";
        Printf.fprintf oc "%d;" (int_of_string(id));
    Printf.fprintf oc "/home/racha/Documents/stage/workflow_Can/Output/part3.ppm\n";
        Printf.fprintf oc "%d;" (int_of_string(id));
    Printf.fprintf oc "/home/racha/Documents/stage/workflow_Can/Output/part4.ppm\n";
  
    close_out oc;

 
  end;
