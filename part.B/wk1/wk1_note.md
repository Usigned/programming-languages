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
- head: `car`
  - 同sml中的`hd`
- tail: `cdr`
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

