# Racket basic

# 注释

```Racket
; this is a comments
```

# 表达式

- syntax: `func param1 ... paramn`
- racket中运算符也是函数?，须全部写成前缀表达式，用空格分隔
  - 加法 2+2 =>`(+ 2 2)`
  - 乘法 2* 3=> `(* 3 3)`

- **每个表达式必须用括号括起来**

# 定义变量

- syntax: `(define valName value)`
  - `(define x 3)`
  - `(define y (+ 3 x))`

# 定义函数

- syntax

  ```
  (define funcName
  	(lambda (params) (funBody)))
  
  (define cube
  	(lambda (x) (* x (* x x))))
  ```

  - 使用`lambda`声明一个匿名函数，然后将其赋值给变量名

- 有些函数可以接受多个参数

  - 如`(* x x x)` 表示 $x^3$
  - 语言特性，而不是元组或curry的语法糖

## 函数语法糖

省略`lambda`

```
(define (funcName params)
		(funBody))

(define (cube x)
	(* x x x))
```

## 递归

```
; x的y次方
(define (pow1 x y)
	(if (= y 0)
		1
		(* x (pow x (- y 1)))))
```

> racket中的if
>
> `if condition exp1 exp2`

curry版本：（racket中curry不常用）

```Racket
(define pow2
	(lambda (x)
		lambda (y)
			(pow x y)))
```

## Sum up

```
(e0 e1 ... en)
```

- 如果`e0`是**被赋值为函数的表达式**，则是整个括号中内容为函数调用
- 如果`e0`不是函数，如`define/if/lambda`等，则不是函数调用

# List

> list可以有不同的类型

- 空list: `null`

  > racket中的true/false为#t/#f

- 添加元素: `cons element list`
  - element将添加到List前
  - `(cons 1 (list 2 3 4))`=>`(1 2 3 4)`
- **head**: `car`
  
  - 同sml中的`hd`
- **tail**: `cdr`
  
  - 同sml中的`tl`
- 是否为空: `null?`
- list构造器: `list`
  - `(list e1 ... en)`

# Syntax

racket中的term都可以归属于以下几种

1. atom: `#t, #f, 34, "str", null, 4.0 x, ...`
2. special form: `define, lambda, if`
   - 宏macros

3. terms的序列： `(t1 t2 ... tn)`
   - 若`t1`为special form，那么序列的语义是特殊的
   - 否则是一个函数调用
   - e.g. 
     - 函数调用`(+ 3 (car xs))`
     - special`(lambda (x) (if x "hi" #t))`

> Note
>
> 1. racket中可以用`[]`来代替`()`
>
> 2. racket中程序的文本被组织为树状（前缀表达式），故不存在“操作优先级”
>
> 3. racket的括号类似html的标签

> `(a)`代表调用`a`而不提供参数

# 动态类型

> 使用 `type? e`来判读类型，例子
>
> - `string? "afafaf"` => `#t`
> - `number? val`

# Cond

> 用于代替嵌套的if-else

syntax

```
(cond 	[e1a e1b]
		[e2 e2b]
		...
		[eNa eNb])
```

1. `[e1a e1b]`前者是条件，后者是值
2. 当第一个`exa`返回`#t`时，进入
3. 一般情况下，最后一个`eNa`应该时`#t`(做为default)

> 基本上就是switch

在`if/cond`的条件中，条件不是`#f`就会被判断为`#t`（空list等都相当于`#t`）

# 局部binding

## let

```
let (
	[e1 v1]
	...
	[eN vN])
	(body)
```

- `[e1 v1] ... [eN vN]`局部binding
  - 局部变量**无法使用**先前的局部变量（ML中可以）
  - body中可以使用所有先前变量
  - 典型用例是当局部变量和外部重名时`let ([x y] [y x])`，可以保证统一使用外部变量

exp

```
(define (silly-double x)
	(let ([x (+ x 3)] [y (+ x 2)])
		(+ x y -5)))
```

- 此时binding中赋值时的`x`都是参数中的`x`

## let*

```
let* (
	[e1 v1]
	...
	[eN vN])
	(body)
```

- 局部binding**可以使用**先前的局部binding
  - 相当于ML中的let

## letrec

> let for recursion

```
letrec (
	[e1 v1]
	...
	[eN vN])
	(body)
```

- 局部binding可以使用所有局部binding

  - **无论是前面的还是后面的**

  - 类似ML中的`and`

- 典型用例为 **mutual recursion**

- 表达式执行时仍按顺序执行，若尝试运行时仍未定义值，会报错

> 建议只用于Mutual recursion

## local define

> define嵌套

语义上和**letrec**相同，可以使用所有bindings

```
(define (mod2_b x)
  (define even? (lambda(x)(if (zero? x) #t (odd? (- x 1)))))
  (define odd?  (lambda(x)(if (zero? x) #f (even? (- x 1)))))
  (if (even? x) 0 1))

```

# toplevel bindings

toplevel bindings和`letrec`语义相同：可以使用全部binding

- 无法shadowing，定义两个同名变量会报错

> repl中表现和`let/letrec`都不一致，建议不要在repl中定义递归

> 模块内相当于`letrec`，模块间可以shadow

# set! 赋值

```
(set! x e) 
```

- 将`x`的值变成`e`

- 相当于python/java等中的`x = e`

## begin

```
(begin e1 e2 ... en)
```

- 按顺序执行`e1 e2 ... en`
- 表达式的值为最后一个`en`的值
- 常用于获取`e1 e2 ...`等的副作用

## set!会改变lexical scope中的值

```
(define b 3) 
(define f (lambda (x) (* 1 (+ x b)))) 
(define c (+ b 4)) ;7
(set! b 5)
(define z (f 4))   ;9
(define w c)    ;7
```

- 第5行中由于`b`被重新赋值，`f`的作用改变了

