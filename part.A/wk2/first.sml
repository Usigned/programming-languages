(* 注释   Standard ML - SML *)

val x = 34; (* int *)
(* static env: x : int *)
(* dynamic env x -- > 34 *)

val y = 17;
(* dynamic env x --> 34, y--> 17 *)

val z = (x + y) + (y + 2);
(* dynamic env x --> 34, y--> 17, z --> 70 *)

val q = z + 1;
(* dynamic env x --> 34, y--> 17, z --> 70, w --> 71 *)


fun pow(x : int, y : int) = 
    if y = 0
    then 1
    else x * pow(x, y-1)