
fun my_n_times (f, n, x) = 
   if n = 0
   then x 
   else f (my_n_times(f, n-1, x))



val x = my_n_times(tl, 2, [4,8,12,16])

val x1 = let fun double x = 2*x in my_n_times(double, 2, 4) end