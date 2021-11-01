(* map, filter, reduce *)

(* 通过一个映射函数，将一个列表中的元素映射到另一个数组 *)
(* 参数：'a -> 'b * 'a list *)
(* 返回值: 'b list *)
fun map (f, xs) =
    case xs of 
        [] => []|
        x :: xs' => (f x) :: map(f, xs') 

(* 通过一个过滤函数，将列表中不符合要求的元素剔除 *)
(* 参数: 'a -> bool * 'a list*)
(* 返回值: 'a list *)
fun filter (f, xs) = 
    case xs of 
        [] => [] |
        x :: xs' => if (f x )then x :: filter(f, xs') else filter(f, xs')

(* 通过一个累积函数，将列表中元素通过这个积累函数积累到accumulator中 *)
(* 参数：('a * 'b -> 'b) * 'b * 'a list  *)
(* 返回值：'b *)
fun reduce (f, acc, xs) = 
    case xs of 
        [] => acc |
        x :: xs' => reduce(f, f(x, acc), xs')

(* try reduce *)
(* 给定f测试函数，xs列表，判断xs中所有元素是否都通过f测试 *)
fun if_all_good (f, xs) =
    reduce(fn(x, y )=> f x andalso y, true, xs)


fun sum (xs) = fold(fn(x, y) => x+y, 0, xs)


fun is_all_longer_than (xs, s) = 
    let
        val target_len = String.size s
    in
        reduce(fn(x, y) => String.size x > target_len andalso y, true, xs)
    end

is_all_longer_than(["132131231", "adafdaf"], "adfafaff")

fun range_filter_reduce (xs, lo, hi) =
    reduce(fn(x, y) => if x >= lo andalso x <= hi then x + y else y, 0, xs)


if_all_good(fn x => x>0, [1,2,3,4,5,0])

sum([1,3,4,5,5,6,8])

range_filter_reduce([1,2,3,4,5,6,6,6,6], 2, 4)


fun is_all_longer_than2 (xs, s) =
    let
        val min_len = String.size s
    in
        if_all_good(fn x => String.size x > min_len, xs)
    end