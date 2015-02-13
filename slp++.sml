type id = string

datatype binop = Plus | Minus | Times | Div

datatype stm = CompoundStm of stm * stm
	    | AssignStm of id * exp
	    | PrintStm of exp list

     and exp = IdExp of id
      | NumExp of int
      | OpExp of exp * binop * exp
      | EseqExp of stm * exp

(* Environments are lists of bindings *)

val mt-env = []
(* val xtnd-env = equivalent to link in pyret *)

(* Environments and Values *)
datatype Binding = bind of id * int

fun update ((* env, value to lookup, new value -> env updated*)) = 

fun lookup ((* env, value to lookup -> int*))= 

fun interpStm 
  | CompoundStm = (* new env*)
  | AssignStm = (* new env*)
  | PrintStm = (* new env*)

fun interpExp 
  | NumExp = (* new env*)
  | OpExp = (* new env*)
  | EseqExp =  (* new env*)

fun interp 
  | stm = (* interpStm *)
  | exp = (* interpExp *)


val prog = 
  CompoundStm(AssignStm("a",OpExp(NumExp 5, Plus, NumExp 3)),
  CompoundStm(AssignStm("b",
      EseqExp(PrintStm[IdExp"a",OpExp(IdExp"a", Minus,NumExp 1)],
           OpExp(NumExp 10, Times, IdExp"a"))),
   PrintStm[IdExp "b"]))

