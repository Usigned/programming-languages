(* Coursera Programming Languages, Homework 3, Provided Code *)


fun only_capitals strings = 
	List.filter (fn x => Char.isUpper (String.sub(x, 0))) strings

fun longest_string1 strings = 
	List.foldl (fn (x, acc) => if String.size x > String.size acc then x else acc) "" strings

fun longest_string2 strings = 
	List.foldl (fn (x, acc) => if String.size x >= String.size acc then x else acc) "" strings

fun longest_string_helper f strings = 
	List.foldl (fn (x, acc) => if f(String.size x, String.size acc) then x else acc) "" strings

val longest_string3 = longest_string_helper (fn (x, y) => x > y)

val longest_string4 = longest_string_helper (fn (x, y) => x >= y)

val longest_capitalized = longest_string1 o only_capitals

val rev_string = String.implode o List.rev o String.explode

exception NoAnswer

fun first_answer f xs = 
	case xs of
		[] => raise NoAnswer |
		x :: xs' => case f x of
						SOME v => v |
						NONE => first_answer f xs'

fun all_answers f xs = 
	let
		fun aux (x, acc) = 
			case (f x, acc) of
				(NONE, _) => NONE |
				(_, NONE) => NONE |
				(SOME x, SOME acc) => SOME (x @ acc) 
	in
		List.foldl aux (SOME []) xs
	end


datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

val count_wildcards = g (fn () => 1) (fn _ => 0)





(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)