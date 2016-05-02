
(** VecAdd.ml                                           *)
(** Add 2 vectors allocated from OCaml                  *)
(** Use prewritten kernel accessible from Spoc          *)
(**                                                     *)
(** based on Mathias Bourgoin - 2011   work             *)

open Spoc
(* kernel, fichier, nom de kernel*)

kernel vec_add :  Spoc.Vector.vfloat32-> Spoc.Vector.vfloat32->Spoc.Vector.vfloat32 -> int -> unit = "kernels/Spoc_kernels" "vec_add"


let devices = Spoc.Devices.init ()
   
     
let dev = ref devices.(0)
let vec_size = ref 1024
let auto_transfers = ref false
let verify = ref true
let files = ref []

let _ =

  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, file1, file2 = match args with 
  | [id; file1; file2] -> id, file1, file2
  | _ -> failwith "args error"
  in

  let parse_floats f =
    let fd = open_in f in
	let _ = input_line fd in
    let l = ref [] in
    let rec aux () = match input_line fd with
      | s -> l := float_of_string (String.trim s) :: !l ; aux () 
      | exception End_of_file -> ()
      | exception Failure _ -> failwith "error"
    in aux (); close_in fd; !l
  in
    
  let floats1, floats2 = parse_floats file1, parse_floats file2 in
  
  Spoc.Mem.auto_transfers !auto_transfers;
  Printf.printf "Will use device : %s\n" (!dev).Spoc.Devices.general_info.Spoc.Devices.name;
let sortie = "file" ^(id) ; in

    begin
 
      Printf.printf "Will use simple precision\n"; 
      Printf.printf "Allocating Vectors (on CPU memory)\n";
      flush stdout;    
      let a = Spoc.Vector.create Spoc.Vector.float32 (!vec_size)
      and b = Spoc.Vector.create Spoc.Vector.float32 (!vec_size)
      and res = Spoc.Vector.create Spoc.Vector.float32 (!vec_size) in

      let vec_add = vec_add in  
      for i = 0 to (Spoc.Vector.length a - 1) do
      List.iteri (Spoc.Mem.set a) floats1;
      List.iteri (Spoc.Mem.set b) floats2;
     (* Spoc.Mem.set a i ( List.nth floats1 i);*)
      (*Spoc.Mem.set b i ( List.nth floats2 i );*)

      done;
      if (not !auto_transfers) then
	begin
	  Printf.printf "Transfering Values (on Device memory)\n";
	  flush stdout;
	  Spoc.Mem.to_device a !dev;
	   Spoc.Mem.to_device b !dev;
	  Spoc.Mem.to_device res !dev;
	  
    (* Kernel launch : computation *)
	end;
      begin
      
    	Printf.printf "Computing \n";
    	flush stdout;
let threadsPerBlock = match !dev.Devices.specific_info with
      	  | Devices.OpenCLInfo clI ->
            (match clI.Devices.device_type with
            | Devices.CL_DEVICE_TYPE_CPU -> 1 (*si c'est un cl device renvoie 1 sinon _ pour tous les autres cas renvoie 256*)
            | _ -> 256)
      	  | _ -> 256
    	in
    	let blocksPerGrid = (!vec_size + threadsPerBlock -1) / threadsPerBlock in
    	let block = { Spoc.Kernel.blockX = threadsPerBlock; Spoc.Kernel.blockY = 1 ; Spoc.Kernel.blockZ = 1;} in
    	let grid = { Spoc.Kernel.gridX = blocksPerGrid; Spoc.Kernel.gridY = 1 ; Spoc.Kernel.gridZ = 1;} in
	
	vec_add#compile (~debug: true) !dev;
    	Spoc.Kernel.run !dev (block, grid) vec_add (a, b,res, !vec_size);
    	Pervasives.flush stdout;
      end;	
      if (not !auto_transfers) then
	begin
	  Printf.printf "Transfering Vectors (on CPU memory)\n";
	  Pervasives.flush stdout;
	  Spoc.Mem.to_cpu res ();
	end;
      Spoc.Devices.flush !dev ();
      let oc1 = open_out sortie in 
        Printf.fprintf oc1 "K\n";
     for i = 0 to (Spoc.Vector.length res - 1) do
      	Printf.fprintf oc1 "%.3f\n" (Spoc.Mem.get res i);
		done;
	close_out oc1;
	
  let oc = open_out "ERelation.txt" in
	Printf.fprintf oc "id;f1;f2;f3\n";
	Printf.fprintf oc "%s;" id;
	Printf.fprintf oc "%s;" file1;
	Printf.fprintf oc "%s;" file2;
    Printf.fprintf oc "%s\n" sortie;
 close_out oc;
    end; 
 


