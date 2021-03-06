(* one-of type *)
(* typename: mytype *)
(* constructors: TwoInts, Str, Pizza *)
(* 有点类似枚举类型 *)
(* constructor是一个函数(或值) *)
(* 更正：比枚举类型复杂，有点像类继承，枚举类型的话三个constructor应该都没of
mytype是一个接口父类，TwoInts, Str, Pizza实现了这个接口
其中TwoInts类型中有两个int字段，Str中有一个string字段，Pizza中无字段 *)
datatype mytype = 
    TwoInts of int * int
    | Str of string
    | Pizza;

(TwoInts, Pizza, Str);

val a = Str "hi"

val b = Str

val c = Pizza

val d = TwoInts(3, 7)

val e = a

(* fun
check variants
extract data *)

(* case expersion *)
fun extract(x: mytype) =
    case x of
        Pizza => 1
        | Str s => String.size(s)
        | TwoInts(i1, i2) => i1 + i2;

datatype id = StudentNum of int
			| StudentName of (string * (string option) * string)


datatype exp = Constant of int
                | Negate of exp
                | Add of exp * exp
                | Multiply of exp * exp

val expression = Add(Constant(19), Negate(Constant(2)));

fun eval(e: exp) = 
	case e of 
		Constant(e1) => e1|
		Negate(e2) => ~(eval(e2))|
        Add(e3, e4) => eval(e3) + eval(e4)|
        Multiply(e5, e6) => eval(e5) * eval(e6)

type alias = mytype


datatype ('a, 'b,'c) polymorphic_type =
    NONE |
    Tuple of 'a * 'b * 'c 

val x: (int, string, bool) polymorphic_type = Tuple(1, "a", true)


fun match_tuple(tuple) = 
    case tuple of
        (x, y, z) => x + y + z

(* int list -> bool *)
fun nondecreasing xs = 
    case xs of
        [] => true |
        _ :: [] => true |
        x1 :: (x2 :: xs'') => (
            x1 <= x2 andalso nondecreasing(x2 :: xs'')
        )

nondecreasing([1,2,2,3,4,3])

datatype sgn = P | N | Z

fun len xs = 
    case xs of 
        [] => 0 |
        _ :: xs' => 1 + len xs'



fun doIt q =
    case q of
	[] => A
  | x::xs =>
        if B
        then C
        else let val res = D;
            in E :: xs end	