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

  - 否则`fun`就是匿名函数的语法

  ```
  fun triple x = 3*x
  
  val triple = fn y => 3*y
  ```

## 避免不必要的匿名函数

1. `fn y => f y`和`f`完全等价，我们应该使用后者

> 函数引用 vs lambda

2. `fun rev xs = List.rev xs`应该替换为`val rev = List.rev`