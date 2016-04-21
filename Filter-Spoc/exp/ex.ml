
let id = ref 0
let line1 = 0.0
let line2 = 0.0
let vec_size = ref 1024
let auto_transfers = ref false
let verify = ref true

let l1=0
let l2=0

let files = ref []

let rec nth (lst : string list) (n : int) : string =
match lst with
   h :: t -> if n = 0 then h else nth t (n - 1)
 | [] -> raise Not_found
  
let _=
let arg1 =("-device" , Arg.Int (fun i -> id:=i), "number of the device [0]")
 in
 
  Arg.parse ([arg1]) (fun s -> files :=  s:: !files  ) "";
 
  
 
  List.iter (fun s -> Printf.printf " arg %s \n" s) !files;
  
  let args1 = List.rev !files in
  let id, files = 
    match args1 with
    | id :: files -> int_of_string id, files
    | [] -> failwith "error"
  in
 
  let args2 = List.rev files in
   let file1,files =
    match args2 with
    | file1:: files -> file1, files
    | [] -> failwith "error"

in

  let args3 = List.rev files in
   let file2,files =
    match args3 with
    | file2:: files -> file2, files
    | [] -> failwith "error"

in
 Printf.printf " id  : %d\n" id;
  Printf.printf " file  : %s\n" file1;

  Printf.printf " file  : %s\n" file2;

let sortie = "file" ^string_of_int(id) ; in

Printf.printf " sortie  : %s\n" sortie;
