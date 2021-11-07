# 函数式编程

1. 在大多数/所有情况下避免改变（不可变）
2. **将函数视为值（一等函数）**

> 函数式语言：鼓励函数式编程的语言

# 一等函数(first-class function)

函数可以用于任何其他使用value的地方

- 函数是value

- 参数，返回值，赋值给变量，作为元组，数据类型、异常的一部分

**高级函数**

- 将函数作为参数或返回值
- high older function

**函数闭包**

- 函数能使用函数外部的binding

# 函数作为参数

让函数更抽象、通用，利于代码复用、扩展

> java8以后版本也引入

```
(* 将f操作对x进行n次*)
fun n_times (f, n, x) = 
	if n = 0
	then x
	else f (n_times(f, n-1, x))
```

- 高级函数通常是多态的（但没有必然联系）
- `n_times`函数的类型为`('a -> 'a) * int * 'a -> 'a`

- 只要`f`的参数及返回值类型和`x`的类型相同就能运行

  - 可用于`int`加减乘除，亦可用于`list`操作

  ```
  val x1 = let fun double x = 2*x in n_times(double, 2, 4) end
  val x2 = n_times(tl, 2, [1,2,3,4,5,6])
  ```

  

# 匿名函数

> lambda ?

使用let表达式

```
fun triple_n_times(n, x) =
	let 
		fun triple x = 3*x 
    in
		n_times(triple, n, x)
	end

fun triple_n_times(n, x) =
	n_times(let fun triple x = 3*x in triple end, n, x)
```

使用匿名函数

- syntax: `fn` pattern`=>` body

```
fun triple_n_times(n, x) =
	n_times(fn x => 3*x, n, x)
```

- **匿名函数无法定义递归函数**

  - 否则`fun`就是`val`的语法糖

  ```
  fun triple x = 3*x
  
  val triple = fn y => 3*y
  ```

## 避免不必要的匿名函数

1. `fn y => f y`和`f`完全等价，我们应该使用后者

> 函数引用 vs lambda

2. `fun rev xs = List.rev xs`应该替换为`val rev = List.rev`

# Map & Filter

两个著名的高级函数

## Map

将函数`f`应用到列表`xs`中每个元素上，并返回一个列表

```
fun map (f, xs） = 
	case xs of 
		[] => [] |
		x :: xs' => (f x) :: map(f, xs')
```

- `f`是一个映射函数，将元素转换为另一种类型，其类型为`'a ->'b`
- `map`的类型是: `('a -> 'b) * 'a list -> 'b list`
- ML内置`List.map`
  - 库函数是[柯里化的函数](#Curry（函数柯里化）)

## Filter

函数`f`判断是否保留`xs`中的元素

```
fun filter(f, xs) = 
	case xs of
		[] => [] |
		x :: xs' => if f x then x :: (filter(f, xs')) else filter(f, xs')
```

- `f`是一个判断函数，判断是否元素是否符合要求，其类型为`'a -> bool`
- `filter`类型为`('a -> bool) * 'a list -> 'a list`
- ML内置`List.filter`

## 泛化

高级函数可以即接收函数作为参数，又将函数作为返回值

> sml repl中默认括号在后
>
> ```
> (int -> bool) -> int -> int
> =>
> (int -> bool) -> (int -> int)
> 
> t1 -> t2 -> t3 -> t4
> => 
> t1 -> (t2 -> (t3 ->t4))
> ```

# 静态作用域Lexical Scope

- ML中函数不仅能使用参数和内部局部变量，还能使用动态环境中已有的绑定

- 函数可以被传到不同的地方，
- 函数定义的地方可能不是函数被调用的地方 lexical scope

例子

```
(*1*)val x = 1
(*x为1*)
(*2*)fun f y = x + y
(* f是一个将其参数加1的函数*)
(*3*)val x = 2
(*shadow之前的x*)
(*4*)val y = 3
(*y为3*)
(*5*)val z = f (x+y)
(* z值为6(5 + 1)，f还是加1而不是2*)
```

1. 查找`f`定义
2. 计算`x+y` = 5
3. 将5作为参数调用`f`，调用时函数体部分在**原来的环境**中执行（即x=1）

## 函数闭包

如何获取原来的环境？

- 一个函数的值有两部分

  1. `code`

  2. `环境`

- 故函数值是一个二元组(pair)，称为closure闭包

- 调用时，将`code`在`环境`中执行

在上述例子中：

第2行创建了一个闭包并绑定到`f`

- code: "接收输入y，函数体x+y"
- env：“x为1”

第5行用5做参数调用闭包

> closure是lexical scope的一种实现

> 查阅了lexical scoping资料，了解了一下lexical scoping vs dynamic scoping，知乎有篇关于[python的讨论](https://www.zhihu.com/question/24179082)感觉有点意思。
>
> 通俗来说静态作用域从**函数定义时**的环境中查找，而动态作用域则从**函数调用时**当前环境中查找

## Why Lexical?

- **lexical scope**: 使用函数定义时的环境

- dynamic scope: 使用函数调用时的环境

> 如今编程语言都是lexical scope

> dynamic scope效果类似于将函数**直接替换**

lexical scope中

1. 变量名不会影响语义
   - 动态环境中就会影响
2. 函数在定义时就可以知道行为、类型，而不是运行时 

3. 闭包可以储存数据？

> 处理异常的方法类似dynamic scope

# 使用闭包来避免重复计算

```
fun allShorterThan1 (xs,s) = 
    filter (fn x => String.size x < (print "!"; String.size s), xs)
```

此时`String.size s`是可以避免的重复计算

```
fun allShorterThan2 (xs,s) =
    let 
		val i = (print "!"; String.size s)
    in
		filter(fn x => String.size x < i, xs)
    end
```

这里匿名函数内部用到了外部的变量`i`，故是一个闭包

# Fold(reduce/inject)

输入集合输出一个值

- 给定一个函数、一个集合、一个初始值，将集合中每个元素用函数积累到值中

- `fold(f,acc,[x1,x2,x3,x4])`=> `f(f(f(f(acc,x1),x2),x3),x4)`

```
fun fold (f, acc, xs) = 
	case xs of
		[] => [] |
		x :: xs' => fold(f,f(acc,x),xs')
```

- 积累的顺序是否有影响取决于`f`（上述是fold left）

- `fold`类型为`('a * 'b -> 'a) * 'b * 'b list -> 'a `

> 通过一个积累函数`f`，将列表中元素通过这个积累函数积累到accumulator中
>
> `f`类型：`'a * 'b -> 'a`
>
> `fold`
>
> *(\* 参数：('a \* 'b -> 'b) \* 'b \* 'a list  \*)*
>
> *(\* 返回值：'b \*)*

# 函数组合

```
fun compose (f, g) = fn x => f (g x)
```

- 组合`f`和`g`

## ML中内置的函数组合运算符`o`

- syntax: `(f o g) param`

- eval: 等价于`f(g(param))`
- 例子

```SML
fun sqrt_of_abs i = Math.sqrt(Real.fromInt(abs i)))
(*等价于*)
fun sqrt_of_abs i = (Math.sqrt o Real.fromInt o abs) i
```

##  自定义运算符

`o`的执行顺序是从右到左，不符合阅读习惯，反直觉。

可以通过ML提供的自定义运算符自定义从左到右的函数结合运算

- syntax: 

  - `infix |>` 

    - 申明一个中缀运算符`|>`

      > infix意为中缀

  - `fun x |> f = f x`

    - 定义这个运算符为调用函数

- example

  - 使用自定义符号来实现函数结合

  ```
  infix |> (* c#中的定义 *)
  fun x |> f = f x
  
  fun sqrt_of_abs i = i |> abs |> Real.fromInt |> Math.sqrt
  ```

## 其他组合方式

比如：当第一个函数返回NONE时，则调用第二个函数

```
fun backup1(f,g) = fn x => case f x of 
								NONE => g x |
                                SOME y => y

fun backup2(f, g) = fn x => fx handle _ => g x
```

# Curry（函数柯里化）

> ML中每个函数接收一个参数
>
> 想要传多个参数可以
>
> 1. 通过元组传递
> 2. Curry

Curry：利用闭包一个个传递参数

Example:

1. 通过tuple传递多个参数

   ```SML
   fun sorted3_tuple (x,y,z) = x >= y andalso y >=z
   ```

   - `sorted3_tuple`类型为`int * int * int -> bool`

2. curry

   ```SML
   val sorted3 = fn x => fn y => fn z => x >= y andaslo y >= z
   (* 调用 *)
   ((sorted3 7)9)11
   ```

   - `sorted3`类型为`int -> int -> int -> bool`
   - 调用的本质为`sorted3(7)(9)(11)`
     - 除了最后一次，每次调用的返回结果都为一个函数
     - 而上一次调用的函数参数通过闭包来提供给下一个函数调用使用

> 个人理解：curry化就是将一个多参数函数转变为一系列的单参数函数连续调用
>
> ```
> fun function (p1, p2, p3) = body
> (* 柯里化 *)
> fun function p = fn p1 => fn p2 => fn p3 => body
> ```
>
> 柯里化依赖于闭包特性？（否则最后一个函数如何访问先前参数？）

## ML对curry提供的语法糖

1. 调用可省略括号

   ```
   ((sorted3 7)9)11
   (* 简化 *)
   sorted3 7 9 11
   ```

2. 定义时可以省略匿名韩素

   ```
   val sorted3 = fn x => fn y => fn z => z >= y andalso y >= x
   (* 简化 *)
   fun sorted3_nicer x y z = z >= y andalso y>= x
   ```

## 使用柯里化函数来使用部分应用

> partial application

柯里化的函数可以分开调用

> 有点类似wrapper

比如可以把`sorted3`改造为判断正负函数

```
val is_neg = sorted3 0 0
```

事实上ML中的库提供的高级函数基本都是curry的，比如`List.map`, `List.filter`

**Value Restriction**

使用partial application来创建多态函数时，可能会出现“值限制”

- 出现警告，且无法调用
- 如下语句会出现警告

```
val pairWithOne = List.map (fn x => (x, 1))
```

## Curry wrap

tuple函数和curry函数转化

```
fun curry f x y = f (x,y)

fun uncurry f (x,y) = f x y 
```

- `curry`函数的类型为`('a *'b -> 'c) -> 'a -> 'b -> 'c`
- `uncurry`的类型为`('a->'b->'c) -> 'a * 'b -> 'c`

交换curry顺序

```
fun other_curry f x y = f y x
```

- 类型为`('a -> 'b ->'c)-> 'b -> 'a -> 'c`

## Curry效率

curry函数效率取决于语言的实现

- SML中tuple函数比curry快
- 一些编程语言中curry更高效(Haskell, F#?)

# ML中的可变类型

引用（Reference）

> c中的指针

- 类型: `t ref`

- syntax
  - 初始化`ref e`
  - 赋值`e1 := e2`
  - 获取值`!e`

```
val x = ref 42
val y = ref 42
val z = x
val - = x := 43
val w = (!y) + (!z)
```

- 注意`x,y,z`在binding后是不可变的，实践变的是其指向的区域中的值

- 比如在绑定后想把`x`指向元组则类型检查无法通

  ```
  val x = ref 42
  (* x 类型为 int ref *)
  x := 123
  (* x指向的区域的值更新为42 *)
  x := (1,2,3,4)
  (* 无法通过类型检查 *)
  ```

> 个人理解：x和一个`int`类型的区域绑定了

# 回调函数(callbacks)

[What the fuck is Callbacks? | Archive (usigned.github.io)](https://usigned.github.io/2021/11/04/What-the-fuck-is-Callbacks/)

# Abstract Data Type

将函数装入record中

# Addition

| type            | dynamic type | static type   |
| --------------- | ------------ | ------------- |
| functional      | Racket       | SML           |
| object-oriented | Ruby         | Java/C#/Scala |

- SML: 多态类型， pattern-matching, 抽象类型&模块
- Racket: 动态类型，宏，最小化语法，eval
- Ruby: 面向对象
