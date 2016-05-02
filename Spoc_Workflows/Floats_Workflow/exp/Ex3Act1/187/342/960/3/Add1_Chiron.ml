

open Spoc
(* kernel, fichier, nom de kernel*)

kernel vec_add :  Spoc.Vector.vfloat32-> Spoc.Vector.vfloat32->Spoc.Vector.vfloat32 -> int -> unit = "kernels/Spoc_kernels" "vec_add"


let devices = Spoc.Devices.init ()
   
     
let dev = ref devices.(0)
let vec_size = ref 1
let auto_transfers = ref false
let verify = ref true
let ars = ref []

    let _ =

  Arg.parse ([]) (fun s -> ars :=  s:: !ars  ) "";
  Random.self_init();
  let args = List.rev !ars in
  let id, t1, t2 = match args with 
  | [id; t1; t2] -> id, t1, t2
  | _ -> failwith "args error"
  in
 
  
  Spoc.Mem.auto_transfers !auto_transfers;
  Printf.printf "Will use device : %s\n" (!dev).Spoc.Devices.general_info.Spoc.Devices.name;


    begin
 
      Printf.printf "Will use simple precision\n"; 
      Printf.printf "Allocating Vectors (on CPU memory)\n";
      flush stdout;    
      let a = Spoc.Vector.create Spoc.Vector.float32 (!vec_size)
      and b = Spoc.Vector.create Spoc.Vector.float32 (!vec_size)
      and res = Spoc.Vector.create Spoc.Vector.float32 (!vec_size) in

      let vec_add = vec_add in  
      for i = 0 to (Spoc.Vector.length a - 1) do
      
      Spoc.Mem.set a 0 ( float_of_string t1 );
     Spoc.Mem.set b 0 ( float_of_string t2 );

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

	
  let oc = open_out "ERelation.txt" in
	Printf.fprintf oc "id;t1;t2;t3\n";
	Printf.fprintf oc "%s;" id;
	Printf.fprintf oc "%s;" t1;
	Printf.fprintf oc "%s;" t2;
 	Printf.fprintf oc "%3.f;" (Spoc.Mem.get res 0);
 close_out oc;
    end; 
 


