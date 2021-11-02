
fun my_n_times (f, n, x) = 
   if n = 0
   then x 
   else f (my_n_times(f, n-1, x))



val x = my_n_times(tl, 2, [4,8,12,16])

val x1 = let fun double x = 2*x in my_n_times(double, 2, 4) end



fun map (f, xs) = 
   case xs of 
      [] => [] |
      x :: xs' => (f(x)) :: map(f, xs')


val x1 = map((fn x => x + 1), [1,2,3,4])

val x2 = map(hd, [[1,2,3,4],[4,4,4,4]])


fun filter(f, xs) = 
   case xs of 
      [] => [] |
      x :: xs' => if f x then x :: filter(f, xs') else filter(f, xs')


fun all_even xs = filter(fn v => (v mod 2 = 0), xs)


all_even([1,2,3,4,5,6]) 


fun d_or_t f =
   if f 7
   then fn x => 2*x 
   else fn x => 3*x


val d = d_or_t(fn _=> true)

val t = d_or_t(fn _ => false)



fun process_all_of_constant (f, e) = 
   case e of
      Constant i => f i |
      Negate e1 => process_all_of_constant(f, e1) |
      Add (e1, e2) => process_all_of_constant(f, e1) andalso process_all_of_constant(f, e2) |
      Multiply (e1, e2) => process_all_of_constant(f, e1) andalso process_all_of_constant(f, e2)
