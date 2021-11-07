(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

val test1 = only_capitals ["A","B","C"] = ["A","B","C"]

val test2 = longest_string1 ["A","bc","C"] = "bc"

val test3 = longest_string2 ["A","bc","ab", "C"] = "ab"

val test4a = longest_string3 ["A","bc","C"] = "bc"

val test4b = longest_string4 ["A","B","C"] = "C"

val test5 = longest_capitalized ["A","bc","C"] = "A"

val test6 = rev_string "abc" = "cba"

val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4

val test8 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE

val test9a = count_wildcards (TupleP([Wildcard, TupleP([Wildcard, Wildcard, ConstructorP("aada", Wildcard)])])) = 4

val test9b = count_wild_and_variable_lengths (TupleP([Wildcard, TupleP([Wildcard, Variable("abcd"), ConstructorP("aada", Wildcard), Variable("abcd")])])) = 11

val test9c = count_some_var ("x", TupleP([Wildcard, TupleP([Wildcard, Variable("x"), ConstructorP("x", Wildcard), Variable("x")])])) = 2

val test10 = check_pat (TupleP([Wildcard, TupleP([Wildcard, Variable("x"), ConstructorP("x", Wildcard), Variable("y")])])) = true

val test11 = match (Tuple([Const(1), Unit, Constructor("x", Unit)]),TupleP([Variable("y"), Variable("x"), ConstructorP("x", Wildcard)])) = SOME [("x", Unit), ("y", Const(1))]

val test12 = first_match Unit [ConstP(12), UnitP] = SOME []
