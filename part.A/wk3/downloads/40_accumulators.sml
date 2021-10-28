(* Programming Languages, Dan Grossman *)
(* Section 2: Accumulators *)

fun sum1 xs =
    case xs of
        [] => 0
      | i::xs' => i + sum1 xs'

fun my_sum xs = 
    let
        fun f (xs, acc) = 
            case xs of 
                [] => 0 |
                x :: xs' => f(xs', acc + x)
    in 
        f(xs, 0)
    end

fun sum2 xs =
    let fun f (xs,acc) =
            case xs of
                [] => acc
              | i::xs' => f(xs',i+acc)
    in
        f(xs,0)
    end

fun rev1 xs =
   case xs of
       [] => []
     | x::xs' => (rev1 xs') @ [x]

fun my_rev xs = 
    let
        fun aux (xs, acc) = 
            case xs of
                [] => [] |
                x :: xs' => aux(xs', x::acc)
    in
        aux(xs, [])
    end

fun rev2 xs =
    let fun aux(xs,acc) =
            case xs of
                [] => acc
              | x::xs' => aux(xs', x::acc)
    in
        aux(xs,[])
    end
