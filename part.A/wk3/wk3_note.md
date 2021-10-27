# Compound Data Type

>  tuple，list等都是compound type

3中创建混合类型的方式

- "each-of"：t描述(t1, t2,...,tn)中每个值
  - tuple
  - java类中的属性等
- "one-of"：t描述(t1, t2,..,tn)中的一个值
  - `int option`描述一个int或无(NONE)
  - 枚举类型？
- “self-reference”：t指向自己来定义，比如lists/trees

# Records

>  named tuple? dict?

创建：

- syntax: `{f1=v1, f2=v2, f3=v3}`
- type:`{f1:t1, f2:t2, f3:t3}`
- 顺序无关紧要
  - 有点类似python dict

访问内部元素

- syntax: `#f2 record`
- Type Error如果`record`没有`f2`字段
  - type-check时检查

>  record vs tuple -> name vs position

# 语法糖

> syntactic sugar

例子：

ML中tuple是特殊的record

```
- val record = {1="a", 2="b", 3="c"};
val record = ("a","b","c") : string * string * string
- val tuple = ("a", "b", '"c")
val tuple = ("a", "b", '"c") : string * string * string
```

tuple是具有1,2,3..n属性名的record的语法糖

- 语法上：tuple语义上可以完全被record替代

语法糖优势

- 使语言易于理解
- 使语言实现更简单

> 即带来了使用的方便，又维持了语义上的统一

# DataType binding

> Previously
>
> val bindings `val`
>
> fun bindings `fun`

## binding syntax

`datatype` typename = const1 `of` type1 | const2 `of` type2 | const3 `of` type3

one-of类型

```
datatype mytype = 
    TwoInts of int * int
    | Str of string
    | Pizza;
```

- typename: mytype
- constructors: TwoInts, Str, Pizza
  - `TwoInts`类型为`int * int -> mytype`，是一个函数
  - `Str`类型为`string -> mytype`，是一个函数
  - `Pizza`类型为`mytype`，是一个变量

> 有点类似枚举类型
>
> 更正：有点像类继承，枚举类型的话三个constructor应该都没of
>
> mytype是一个接口父类，TwoInts, Str, Pizza实现了这个接口
>
> 其中TwoInts类型中有两个int字段，Str中有一个string字段，Pizza中无字段

- 构造器类似tag来表明是哪一种mytype

## 使用

在创建了类型后，还需要方法来访问其中值得方法

1. 检查元素类型：是`mytype`中哪一种`TwoInts`或`Str`或`Pizza`
2. 提取值：访问`TwoInts/Str`中储存的值

ML中其他`one-of`类型的

# Case

检查、访问数据类型中的值

## syntax

```
fun extract(x: mytype) =
    case x of
        Pizza => 1
        | Str s => String.size(s)
        | TwoInts(i1, i2) => i1 + i2;
```

## Pattern matching

case表达式一般形式

`case` e0 `of`

​	p1 `=>` e1

​	 `|` p2 `=>` e2

​	`|` p3 `=>` e3

> `Pizza`/`Str s` /`TwoInts(i1, i2)`称为pattern（本例中是构造器名+正确数量的参数）
>
> matching: 构造器相同则匹配成功

- 提取data并绑定到对应的局部变量中，这些局部变量只在该分支内有效

- typecheck:  val1, val2, val3类型要相同

> 使用case表达式(pattern matching)可以防止重复pattern出现，或在缺少pattern时报警告
>
> 上述在编译时发生

# Clear up

- constructor: 函数名或值
- pattern = constructor + right num of params
- Pattern matching: 当constructor一样时匹配成功，并将值binding

# 常用数据类型

one-of

- 枚举类型

```
datatype suit = Club | Diamond | Heart | Spade
datatype rank = Jack | Queen | King | Ace | Num of int
```

- 额外表示：如有些学生无学号需要用姓名表示

```
datatype id = StudentNum of int
			| StudentName of (string * string option * string)
```

# Expression Trees

self-reference

```
datatype exp = Constant of int
				| Negate of exp
				| Add of exp * exp
				| Multiply of exp * exp
```

此时若申明一个变量`val add_expression = Add(Constant(1), Negate(Constant(5)))`，我们就得到了一个表达式树（来表示一系列数学运算）

再结合函数可以对表达式进行各种处理，如获取其值

```
fun eval(e: exp) = 
	case e of 
		Constant(e1) => e1|
		Negate(e2) => ~(eval(e2))|
        Add(e3, e4) => eval(e3) + eval(e4)|
        Multiply(e5, e6) => eval(e5) * eval(e6)
```

# Type Synonyms

给类型起别名

- syntax: `type` typename = `t`

  - `t`是一个类型而不是变量

  - 可用于自定义组合类型`type card = suit * rank`

    或者自定义的长record类型，比如

  ```
  type name_record = {
  	student_num: int option,
  	first: string,
  	middle: string option,
  	last: string
  }
  ```

- eval: typename和t完全等价

> 存在目的就是方便使用

> `type`只能用于给类型其别名，给变量(或函数，函数也是变量)起别名使用`val`

# 递归数据结构

ml中的list和option本质上也是datatype定义（list中加入了运算符重载？）

比如我们可以自定义列表

```
datatype my_int_list = Empty | Cons of int * my_int_list

val my_int_list_demo = Cons(1, Cons(2, Cons(3, Empty)))
```

之后通过case来访问

```
fun append_my_list(xs, ys) = 
	case xs of
		Empty => ys |
		Cons(x, xs') => Cons(x, append_my_list(xs', ys))
```

> xs' 读作 xs prime

## 使用case来访问option

```
fun inc_or_zero(intoption) = 
	case intoption of
		NONE => 0 |
		SOME i => i+1
```

ML会自动识别intoption的类型（为`int option`）

- `NONE`/ `SOME`本质上就是constructor

## 使用case来访问list

```
fun append(xs, ys) = 
	case xs of
		[] => ys |
		x :: xs' => x :: append(xs', ys)
```

这里`[]`和`::`只是长相奇怪的constructor

# 多态数据类型

接受数据类型作为参数

> 范型？

ML中`list`/`option`是多态**类型构造器**

- ML中list和option可以是`int list/string list`等等

- 函数可以接受多种类型输入`val append : 'a list * 'a list -> 'a list'`

**自定义多态数据类型**

```
datatype 'a option = NONE | SOME of 'a
datatype ('a, 'b) tree = 
	Node of 'a * ('a, 'b) tree * ('a, 'b) tree |
	Leaf of 'b
```

- Syntax: 使用`'`符号修饰类型参数

- eval: 使用多态数据类型在运行行为上无影响
- Type-check: 需要保证类型一致

- 函数中类型会根据数据运算来推断

> 类型参数用逗号分隔，参数用星号分隔

```
datatype ('a, 'b,'c) polymorphic_type = 
	NONE |
	Tuple of 'a * 'b * 'c

val x: (int, string, bool) polymorphic_type = Tuple(1, "a", true)
```

此时`x`的类型为`(int, string, bool) polymorphic_type`而不是`(int * string * bool) polymorphic_type`

# Val/Fun with pattern matching

ML中所有变量，函数都使用模式匹配（都是语法糖）

>  [previously on one-of type pattern matching](#Pattern matching)

each-of类型模式匹配

- tuple pattern `(x1, ..., xn)`

  匹配值`(v1, v2, ..., vn)`，数量、类型须一致

- record pattern `{f1=x1, ..., fn=xn}`

  匹配每个field的值

```
fun add_tuple(tuple) = 
	case tuple of
		(x, y, z) => x + y +z

fun concate_string(name: {first: string, middle:string, last: string}) =
	case r of 
        {first=x,middle=y,last=z} => x ^ " " ^ y ^ " " ^z
```

## 变量pattern

使用模式匹配进行变量绑定

- 变量只是一种pattern
  - `val` pattern = e
  - `val (x, y, z) = (1, "2", true)`

> 有点类似python中tuple unpacking

## 函数pattern

函数的参数是**一个**pattern

`fun` funcName *pattern* = e

- tuple做pattern（之前使用的）

  ```
  fun sum_tuple (x, y, z) = 
  	x + y + z
  ```

- record做pattern

  ```
  fun full_name ({first=x, middle=y, last=z}) = 
  	x ^ " " ^ y ^ " " ^z
  ```

> ML中函数都接受一个tuple类型参数，然后用模式匹配来提取其中的值

# Type Inference

编译器在类型检查时自动识别类型（最general的）

```
fun sum_triple1 (x,y,z) = x + y + z
```

此时类型为`int * int * int -> int`

```
fun sum_triple1 (x,y,z) = x + z
```

此时类型为`int * 'a * int -> int`

# 多态和等价类型

**more general原则**

如果能将type1中的类型变量统一替换并得到t2，则说明type1比type2更general

**more general原则和等价原则结合**

> 等价原则：record中的顺序无关紧要，有相同字段=》等价

泛化程度排序高=>低

`{quux: 'b, bar: int * 'a, baz: 'b}` >

 `{quux: string, bar: int * int, baz: string}`  = 

`{quux: string, baz: string, bar: int * int}`

## 等价类型equalty type

双引号修饰`''a list * ''a -> bool`

- 受限多态类型：该类型需要能够用`=`运算符
- 多数类型可以int, string, tuple等
- 少数不行，如real, 函数

> ML中=比较特殊，故有一个''a类型

# 嵌套pattern

pattern中嵌套pattern（来避免多个case嵌套，提升代码可读性）

比如判断一个含3个list是否全为空，可以使用case中嵌套case

```
(* bad style*)
fun isEmpty (l1, l2, l3) = 
	case l1 of
		[] => (
			case l2 of
				[] => (
					case l3 of 
						[] => true |
						_ => false
				) |
				_ => false
		) |
		_ => false
```

该方法可读性较差，使用嵌套pattern

```
fun isEmpty list_triple = 
	case list_triple of
		([], [], []) => true |
		_ => false
```

这里`([],[],[])`嵌套pattern即匹配了3元tuple又匹配了每个tuple必须为空列表

同理使用嵌套pattern来实现zip

```
fun zip list_triple = 
	case list_triple of
		([], [], []) => [] |
		(hd1 :: tl1, hd2 :: tl2, hd3 :: tl3) => (hd1, hd2, hd3) :: zip(tl1,tl2,tl3) |
		_ => (*raise exception*)
```

> [使用case来访问list](#使用case来访问list)提到了如何pattern match list
>
> `_`可以匹配任何项，写在其他pattern前会报错`Error: match redundant`
>
> `_`可以像python里一样做没使用变量的占位符，python中应该也是pattern match?

# Pattern Matching Precisely

semantic: 给定一个pattern和一个value，判断是否match，如果match那么引入那些binding?

rules:

1. pattern是一个变量x，则匹配成功并将x绑定到v
   - 比如申明变量`val x = v`

2. pattern是一个wildcard(`_`)，则匹配成功并且不引入任何binding

3. pattern是pattern组成的tuple`(p1,...,pn)`，value是值组成的tuple`(v1,...,vn)`，那么当`p1/v1`...`pn/vn`都匹配成功时，该match成功。引入的binding是所有子匹配过程中引入binding的交集

4. pattern是以pattern为参数的构造器`C p1`，那么匹配成功的条件为

   1. value是以`v1`为参数的相同构造器`C v1`且
   2. `v1/p1`匹配成功

   引入的binding为子匹配过程中引入的binding
