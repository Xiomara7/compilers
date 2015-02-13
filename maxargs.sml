(* maxargs.sml - Functions to process the straight-line programs from
                 Chapter 1 of Modern Compiler Implementation in ML
   Copyright 2014 - Humberto Ortiz-Zuazaga <humberto.ortiz@upr.edu>
*)
use "slp.sml";

(* mutually recursive functions to count args *)

(* 
The assignment says to count the arguments in PrintStm only. I
changed it slightly to count arguments of any statement or expression.
*)

fun maxExp (IdExp id) = 1
	| maxExp (NumExp n) = 1
  (* OpExp can have 3 args or more *)
	| maxExp (OpExp (e1, _, e2)) = Int.max(3, Int.max(maxExp(e1), maxExp(e2)))
  (* EseqExp can have 2 args or more *) 
	| maxExp (EseqExp (s1 , e1)) = Int.max(2, Int.max(maxStm(s1), maxExp(e1)))
  (* AssignStm can have 2 args or more *)
  and maxStm (AssignStm(_, e1)) = Int.max(2, maxExp(e1))
    (* CompoundStm can have 2 args or more *)
  	| maxStm (CompoundStm (s1, s2)) = Int.max(2, Int.max(maxStm(s1), maxStm(s2)))
    (* returns the max between the PrintStm's args and the other exps *)
  	| maxStm (PrintStm eList) = Int.max(List.length eList, maxList(eList))
  (* added another case [maxList] to evaluate the list of exps *)
  and maxList [] = 0
    | maxList (first::rest) = Int.max(maxExp(first), maxList(rest)); 

    (* Alternative PrintStm: 
        Int.max(length eList, foldl Int.max 0 (map maxexp es))
      *)


maxExp (IdExp "a"); (* 1 *)
maxExp (NumExp 5); (* 1 *)
maxExp (OpExp (NumExp 3, Plus, (NumExp 5))); (* 3 *)
maxExp (EseqExp (AssignStm("x", NumExp 4), NumExp 9)); (* 2 *)
maxStm (CompoundStm (AssignStm("b", NumExp 3), AssignStm("x", NumExp 5))); (* 2 *)
maxStm (AssignStm ("a", NumExp 2)); (* 2 *)
maxStm (prog); (* 3 *)
(* Nótese la originalidad de los id's *)
maxStm (CompoundStm(AssignStm("xio", NumExp 3), PrintStm ([NumExp 2, IdExp "xio", EseqExp(AssignStm("xio", NumExp 3), NumExp 4)]))); (* 3 *)


