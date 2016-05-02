let vec_size = ref 10
let files = ref []


let _ =
  Arg.parse ([]) (fun s -> files :=  s:: !files  ) "";
  Random.self_init();
  let args = List.rev !files in
  let id, file1, file2 = match args with 
  | [id; file1; file2] -> id, file1, file2
  | _ -> failwith "args error"
  in

  let parse_ints f =
    let fd = open_in f in
    let _ = input_line fd in
    let l = ref [] in
    let rec aux () = match input_line fd with
      | s -> l := int_of_string (String.trim s) :: !l ; aux ()  
      | exception End_of_file -> ()
      | exception Failure _ -> failwith "error"
    in aux (); close_in fd; !l
  in
    
  let ints1, ints2 = parse_ints file1, parse_ints file2 in
  let sortie = "file" ^(id) ; in


let sum a b =
    let rec isum a b c =
        match a, b with
        | [], [] -> if c = 0 then [] else [c]
        | [], x | x, [] -> isum [0] x c
        | ah :: at, bh :: bt ->
            let s = ah + bh + c in
            (s mod 10) :: isum at bt (s / 10)
    in
    isum a b 0;
in

begin
   let res = sum ints1 ints2 in
     
     let oc1 = open_out sortie in 
  Printf.fprintf oc1 "K\n";
     List.iter ( Printf.fprintf oc1 "%.d\n") res;
	
	close_out oc1;
	
  let oc = open_out "ERelation.txt" in
	Printf.fprintf oc "id;f1;f2;f3\n";
	Printf.fprintf oc "%s;" id;
	Printf.fprintf oc "%s;" file1;
	Printf.fprintf oc "%s;" file2;
    Printf.fprintf oc "%s\n" sortie;
 close_out oc;

 end;
