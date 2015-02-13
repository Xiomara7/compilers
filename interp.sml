(* interp.sml - Functions to interpret the straight-line programs from
    Chapter 1 of Modern Compiler Implementation in ML Copyright 2014 - 
    Humberto Ortiz-Zuazaga <humberto.ortiz@upr.edu> Distributed under 
    the GNU General Public Licence v3. http://www.gnu.org/copyleft/gpl.html
*)
use "slp.sml"; 

val  mtenv = []; (* empty environment*)
type table = (id * int) list; (* env *)

exception UnboundId (* raise: *)

(* update: assigns a value to an id and then adds it to the env 
	returning a new-env with the new pair binded.*)
fun update (table:table, id:id, value:int) = (id, value)::table

(* lookup: func to search for an id in the current env and
	returns the value associated with it, if the id exists *)
fun lookup (table:table, id:id) = 
	case table of [] => raise UnboundId
	|(str, value)::rest  => if (str=id) then value 
					 	   	else lookup(rest, id)

(* interp: mutually recursive funcs to interprets exps and stms *)
fun interpExp (IdExp id, table:table) = (lookup(table, id), table)
  | interpExp (NumExp n, table:table) = (n, table)
  | interpExp (OpExp (exp1, myop, exp2), table:table) = let
													  		val (res1, table1) = interpExp(exp1, table) 
													  		val (res2, table2) = interpExp(exp2, table1) 
													  	in case myop of 
															  Plus  => ((res1  +  res2), table2)
															| Minus => ((res1  -  res2), table2)
															| Times => ((res1  *  res2), table2)
															| Div   => ((res1 div res2), table2)
													  	end
  | interpExp (EseqExp (stm1, exp1), table:table) = let val table1 = interpStm(stm1, table)
														in interpExp(exp1, table1) end
and interpStm (CompoundStm (stm1, stm2), table:table) = let 
														val table1 = interpStm(stm1, table)
														val table2 = interpStm(stm2, table1) 
													in table2 end
  | interpStm (AssignStm (id, exp1), table:table) = let val (value, table1) = interpExp(exp1, table)
													in update(table1, id, value) end
  | interpStm (PrintStm listexp, table:table) = case listexp of [] => table
												  | exp::rest => let val (value, table1) = interpExp(exp, table)
																	in 
																		print(Int.toString value^"\n"); 
																		interpStm(PrintStm rest, table1)
																	end; 

(* TESTS: *)
interpExp(IdExp("a"), [("a", 3)]); 	
(*	(3,[("a",3)])	*)
interpExp(NumExp 3, mtenv); 		
(*	(3,[])	*)
interpExp(OpExp (NumExp 1, Plus, NumExp 4),  mtenv); 
(*	(5,[])	*)
interpExp(OpExp (NumExp 5, Minus, NumExp 1), mtenv); 
(*	(4,[])	*)
interpExp(OpExp (NumExp 2, Times, NumExp 4), mtenv); 
(*	(8,[])	*)
interpExp(OpExp (NumExp 12, Div, NumExp 3),  mtenv); 
(*	(4,[])	*)
interpExp(EseqExp(AssignStm("xio", NumExp 4), NumExp 5), mtenv); 
(*	(5,[("xio",4)])	*)
interpStm(CompoundStm(AssignStm("xio", NumExp 6), AssignStm("xio", NumExp 7)), mtenv); 
(*	[("xio",7),("xio",6)]	*)
interpStm(AssignStm("xio", NumExp 1), mtenv); 
(*	[("xio",1)]	*)
interpStm(PrintStm([NumExp 1, IdExp "a", NumExp 3, IdExp "b"]), [("a", 0), ("b", 7)]); 
(*	1037 [("a",0),("b",7)]	*)



























