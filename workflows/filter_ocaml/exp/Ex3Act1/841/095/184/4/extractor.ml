let ars = ref []

let _ =

  Arg.parse ([]) (fun s -> ars :=  s:: !ars  ) "";
  Random.self_init();
  let args = List.rev !ars in
  let id, t1, t2 = match args with 
  | [id; t1; t2] -> id, t1, t2
  | _ -> failwith "args error"
  in
 
  let oc = open_out "Erelation.txt" in
	if int_of_string(t1) > 1000 then begin
	Printf.fprintf oc "id;t1;t2;t3\n";
	Printf.fprintf oc "%s;" id;
	Printf.fprintf oc "%s;" t1;
	Printf.fprintf oc "%s;" t2;
 close_out oc;
    end; 
 



