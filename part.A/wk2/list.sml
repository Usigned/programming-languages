(* fun getElement(index: int, xs: 'a list) = 
    if null xs
    then -1
    else
        if index = 0
        then hd xs
        else getElement(index-1, tl(xs)) *)

fun list_product(xs: int list) = 
    if null xs
    then 1
    else hd(xs) * list_product(tl(xs))

fun countdown(x: int) = 
    if x = 0
    then []
    else x :: countdown(x-1)

fun append (xs: 'a list, ys: 'a list) = 
    if null xs
    then ys
    else hd(xs) :: append(tl(xs), ys)

fun firsts(xs: (int * int) list) = 
    if null xs
    then []
    else #1 (hd(xs)) :: (firsts(tl(xs)))