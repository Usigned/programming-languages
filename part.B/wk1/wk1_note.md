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

  - 申明同变量
  - 函数体用lambda

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