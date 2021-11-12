- type inference
- mutual recursion
- **module sys**
- equivalence

# Type inference

静态类型检查：编译时类型检查

- 静态类型语言特性

- 动态类型基本不进行处理

| static        | dynamic            |
| ------------- | ------------------ |
| ML/Java/C/... | racket/ruby/python |

## **隐式类型(implicitly typed)**

ML是静态类型，同时也是隐式类型（意味着几乎不用写类型）

- 看上去像python不用写类型，但是实际上和java等语言一样是静态类型

## type inference general

给所有表达式一个类型，以使程序能通过类型检查

- 如果无法找到，则类型检查失败

- 理论上，类型检查程序和类型推断程序可以是两个不同程序，但一般会将二者结合

## ML中的类型推理

步骤：

1. 按照binding的顺序来推断类型
   - mutual recursion除外 ?
   - later binding无法使用：类型检查失败

2. 对于每个binding(`val`/`fun`)
   - 分析每个分支的约束条件，如`x>0`则`x`类型须为`int`
   - 如果有违法约束的情况，则类型错误
3. 使用类型变量(`'a, 'b...`)来替代没有约束的类型

4. (value restriction)

**类型推理和多态类型**

语言可以有类型推理但没有类型变量，或有类型变量没有类型推理

- ML中的类型推理可以推理有类型变量的类型：二者都有

## value restriction

ML中的类型检查是不牢靠的，比如下段例子可以通过类型检查，但会把`string`和`int`相加

```SML
val r = ref NONE (* val r : 'a option ref *)
val _ = r := SOME "hi"
val i = 1 + valOf (!r)
```

> 个人感觉问题在于`NONE`这种是多态"空"类型（wildcard类型？），而且在赋值后类型不会改变，这种wildcard类型在后续可能导致类型不一致错误。
>
> 在java中使用wildcard类型会有warning

ML无法对`ref`类型做特殊处理（由于模块系统），因为类型检查器无法知道所有类型的别名。

故ML设定value restriction：变量binding如果是多态的，那么其表达式只能是变量或是值

- 不能是函数返回值，比如`ref NONE`

- 该规则会产生不必要的影响

  ```SML
  val pairWithOne = List.map (fn x => (x,1))
  (* 其类型应该是'a list -> ('a * int) list'，但由于变量binding的是函数返回值违反了value restriction*)
  ```

> ML的规则指定的尺度合适
>
> 1. 若没有多态（更严格），则制约了程序的可复用性（比如读取List长度的函数应该是什么类型？）
> 2. 若加入了subtyping（更宽松），则十分难实现与管理

# 互递归Mutual Recursion

两个或多个函数相互调用：`f`调用`g`且`g`调用`f`

典型用例：状态机

问题：ML只能使用已有的binding

- ML语言提供支持`and`
- 高级函数

## and关键字

- 函数binding

  ```SML
  fun f1 p1 = e1
  and f2 p2 = e2
  and f3 p3 = e3
  ```

- 数据类型binding

  ```SML
  datatype t1 = ...
  and t2 = ...
  and t3 = ...
  ```

- 用`and`连接的部分会一起类型检查，并且可以相互引用

**有限状态机use case**

每个状态对应一个函数，调用后转到另一个状态

以下展示一个判断List中是否符合规律[1,2] * n

```
fun match xs = 
	let
		fun need_one xs =
			case xs of
				[] => true |
				1 :: xs' => need_two xs' |
				_ => false
  	and need_two xs =
  		case xs of
  			[] => true |
  			2 :: xs' => need_one xs' |
  			_ => false
	in
		need_one xs
	end
```

> 任何有限状态机都可以用上述方法实现

## 不使用关键字

不使用特性来实现前函数调用后函数

> 会比使用关键字慢一些

```SML
fun earlier (f, x) = ... f y ...
(*... *)
fun later x == ... earlier (later, y) ...
```

> 有点类似callback 

# Module Sys

对于大型程序来说只有一层binding是不够的

- 同时也因为binding可以使用所有之前的binding

## Structure

Module中的一种

Syntax:

- 定义

  ```SML
  structure MyModule = struct bindings end
  ```

  - 模块中能使用先前的binding

- 模块外调用模块内binding

  ```SML
  ModuleName.bindingName
  ```

> ModuleName本身不会被引入环境中
>
> Namespace: 基本思想就是binding分层

### Open方法

```SML
open MyModule
```

- 将`MyModule`中所有的`binding`放入顶层binding中

  

## Signatures

Module中的一种定义binding的**名字**和**类型**

> 有点类似接口类

```
signature MATHLIB = 
sig
val fact : int -> int
val half_pi : int
val doubler : int -> int
end

structure MyMathLib :> MATHLIB = 
struct
fun fact x = ...
val half_pi = Math.pi / 2
fun doubler x = x *2
```

- syntax
  - 定义: `signature SigName = sig types-for-bindings end`
  - 实现:`structure MyModule :> SigName = struct ... end`

- 作为module对外界的接口
  - 若module定义时有一签名，那么外界只能访问签名中的方法

### 使用signature隐藏type

在signature使用`type`声明但不指明其类型

```
signature EXAMPLE = 
sig
	type hiddenType
	val createHiddenType : int -> hiddenType
end
```

这样实现该签名的structure只能通过`createHiddenType`来创建`hiddenType`类型数据，而无法自己使用构造器创建

- 此时`hiddenType`为一个抽象数据类型(ADT)
- 若签名中不提供创建该类型的方法，则该签名无法为外界有效使用

> 类似于工厂方法+对象构造器私有化

### signature matching

`structure`应该提供`signature`中定义的所有方法（相同的名称/类型）

> 注意：structure中的类型可以比signature中的更抽象，如signature中有`val func : int * bool -> int`，structure中实现类型为`val func : 'a * 'b -> 'a`此时二者能通过类型检查

# Equivalence

> 不同的签名下，模块的等价性不同。
>
> 原则上暴露在外界(public)的接口越少，两个模块约容易等价。

## 等价条件

在相同的输入下，两个程序

1. 有相同的输出
2. 有相同的终止条件
3. 对内存的操作相同
4. IO操作相同
5. 抛出的异常相同
