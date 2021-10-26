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

extract(Str("fadfafasfsfd"))