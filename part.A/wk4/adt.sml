datatype set = S of {
    insert: int -> set,
    member: int -> bool,
    size: unit -> int
}

(* val empty_set: set *)
(* 纯粹用闭包来储存数据 *)
fun use_sets () = 
    let
        val S s1 = empty_set
        val S s2 = (#insert s1) 34
        val S s3 = (#insert s2) 34
        val S s4 = #insert s3 19
    in
        if (#member s4) 42
        then 99
        else 
            if (#member s4) 19
            then 17 + (#size s3)()
            else 0
    end

val empty_set = 
    let
        fun make_set xs = 
            let
                fun contains i = List.exists (fn j => i=j) xs 
            in
                S {
                    insert = fn x => if contains x then make_set xs else make_set(x :: xs),
                    member = contains,
                    size = fn () => length xs
                }
            end
    in
        make_set []
    end



datatype 'a mylist = Cons of 'a * 'a list | Empty


fun map f xs = 
    case xs of
        Empty => Empty |
        Cons (x, xs') => f x :: map f, xs'

fun filter f xs =
    case xs of
        Empty => Empty |
        Cons (x, xs') => if f x then x :: filter f xs' else filter f xs'

fun length xs = 
    case xs of
        Empty => 0 |
        Cons (_, xs') => 1 + length xs'