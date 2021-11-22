# Racket basic

相比于ml，racket没有静态类型系统且语法较统一（仅三种语法，详见[syntax](#syntax)）

> 语法简单，其实语义挺不优雅的，有各种不统一的现象

[Racket官方文档](http://docs.racket-lang.org/)

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

> racket中list就是多个pair嵌套且以null结尾
>
> - `cons`的作用实际上是将两个元素合成一个pair
> - `car/cdr`的作用实际上相当于ml中的`#1/#2`
> - list相当于一个特殊的嵌套pair
>   - pair中有`.`如`(1 #t . "a")`是一个pair
>
> 体现了racket的动态特性，cons/car/cdr既可以处理list也可以处理pair
>
> - `list?`所有list包括null
> - `pair?`所有用`cons`生产的pair，包括list/pair但不包括null

# 可变list/pair

cons制造的pair是不可变的

```
(define lst (list 1 2 3))
(set! (car lst) 2) ;不支持会报错
```

若需要制造可以变的pair需要使用mcons

```
(define mls (mcons 1 (mcons 2 (mcons 3 null))))
(set-mcar! mls 10) ; mls => (10 2 3)
(set-mcdr! mls 1000) ; mls => (10 1000)
```

- 支持list的不支持`mcons`制造的mlist，需要使用对应的方法
- `mcons/mcar/mcdr/mpair?/set-mcar!/set-mcdr!`

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

运行前无类型检查

>  后续会详细讨论static type和dynamic type

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

- 将环境中`x`的值变成`e`

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

为了防止内部变量被外部改变，需要拷贝一份变量，如

```
(define f
	(let ([b b])
		(lambda (x) (* 1 (+ x b)))))
```

- `let ([b b])` 拷贝了外部的`b`用作内部的`b`

- 为了防止混乱racket禁止在本文件外对`+/*`等预定义的函数使用`set!`重新赋值

# Delayed Evaluations

在ml/java/c等pl中

- 函数的参数是eager的
  - **在调用前就eval**
  - 函数体只有在被调用时才执行
- 条件分支不是eager
  - 在进入时才eval

```
;可以正常执行
(define (factorial-normal x)
  (if (= x 0)
      1
      (* x (factorial-normal (- x 1)))))

;无法正常执行，因为函数的参数是eager的，故会死循环
(define (my-if-bad e1 e2 e3)
  (if e1 e2 e3))

(define (factorial-bad x)
  (my-if-bad (= x 0)
             1
             (* x 
                (factorial-bad (- x 1)))))
                
;使用函数体在被调用时才行的特性，将参数封装在函数中来delay eval
(define (my-if-strange-but-works e1 e2 e3)
  (if e1 (e2) (e3)))

(define (factorial-okay x)
  (my-if-strange-but-works (= x 0)
			   (lambda () 1) ; thunk表达式
			   (lambda () (* x (factorial-okay (- x 1))))))
```

## thunk表达式

无参数的函数来延迟eval

```
e
lambda () e ; thunk expression
(e);eval时调用
```

>  thunk是一种来延迟eval，避免重复、不必要计算的常见手法。

**避免重复计算例子**

只有在特定条件时才需要eval

```
(define (f th)
	(if (...) 0 (... (th) ...)))
```

>  需要根据进入需要th分支的频率来做出trade-off
>
>  我们需要避免多次调用thunk方法
>
>  解决方法：在需要时才eval，eval后保留结果 -- lazy eval

## lazy evaluation(promise)

- 需要时才计算
- 计算完之后保留结果

> 在racket中使用thunk和mcons实现lazy eval
>
> delay  and force - promise
>
> 思路：将thunk封装到一个可变的二元组中(称为**promise**)，其中一个元素表示thunk是否被调用

```
; thunk封装为mpair
(define (my-delay th)
	(mcons #f th))
; 获取pair中的值，使用lazy eval原则
(define (my-force p)
	(if (mcar p)
		(mcdr p) ;thunk已经被调用，直接获取其值
		;thunk未被调用，调用thunk并把flag设置为#t
		(begin [set-mcar! p #t] [set-mcdr! p ((mcdr p))] [mcdr p])))
```

# Streams

无限长的值序列

- 无法获取所有值
- 使用thunk来延迟获取值
- 是一种编程idiom

> 利于分工
>
> - stream生产者知道如何生产任意个数的值
> - stream消费者知道需要获取多少值
>
> stream UNIX pips: `cmd1 | cmd2`，其中`cmd2`从`cmd1`中获取数据

## api

> 使用pair和thunk来代表stream

stream被定义为一个thunk，在调用时返回一个pair`'(next-anser . next-thunk)`

- 获取stream中第一个元素: `(car (s))`
- 获取第二个元素: `(car ((cdr (s))))`
- 第三个: `(car ((cdr ((cdr (s))))))`

> `(cdr (s))`： 获取`(s)`的第二个元素，得到一个thunk(stream)
>
> `((cdr (s)))`: 获取`(s)`的第二个thunk元素，之后调用它，会得到一个pair

> thunk和pair切换时需要注意定义要一致，否则容易出错

## 实现

stream定义为`'(next-anwser . next-thunk)`的thunk

- 主要思想：递归的返回自身（自身即为thunk)

例子

```
; 1 1 1 ...
(define ones (lambda () (cons 1 ones)))

; 1 2 3 4 5 ...
(define (f x) (cons x (lambda () (f (+ x 1)))))
(define natx (lambda () (f 1)))

(define nats
	(letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))]))
	(lambda () (f 1)))

; 2 4 8 16 ...
(define power-of-twos
	(letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))]))
	(lambda () (f 2)))
	
; 抽象化stream, stream-maker接受两个参数fn arg，用于计算下一个元素
(define (stream-maker fn arg)
	(let ([f (lambda (x) (cons x (lambda () (f (fn x arg)))))])
	(lambda () (f arg)))
	
	
; 使用stream-maker定义nats/power-of-twos
(define nats (stream-maker + 1))
(define power-of-twos (stream-maker * 2))
```

> 感觉stream本质上相当于一个generator，根据上一个元素得到下一个元素（stream-maker的功能）。
>
> stream类似一个特殊的链表，不过链表的连接指针是lazy eval的

# Memoization

> 一种避免重复计算的方法

如果一个函数没有副作用，那么以相同参数调用这个函数，其结果会完全一样

- 可以用一个cache来存储计算过的结果

# assoc

```
(assoc key map)
```

查询key是否在map中，若存在返回第一次查询到的该(k v)二元组，否则返回#f

- map是一个二元组组成的list

  ```
  >(define xs (list (cons 1 2) (cons 3 4) (cons 5 6)))
  '((1 . 2) (3 . 4) (5 . 6))
  >(assoc 3 xs)
  '(3 . 4)
  >(assoc 6 xs)
  #f
  ```

# 宏

宏定义指将源码中的一种语法转变为另一种语法

- 宏是一种实现语法糖的方式

宏系统：定义宏的语言

宏扩展：指在程序运行前，将所有宏定义的语法替换为原语法的过程

> rakcet中定义一个宏`m`，使用`(m ...)`会根据定义扩展
>
> e.g 扩展`(my-delay e)`为promise `(mcons #f (lambda () e))`
>
> Note: 不正确使用宏会导致混乱，在必要时再使用宏，否则使用函数

## Tokenization 

通常宏系统在token层面工作，而不是字符序列层面

> 举个例子
>
> 将`head`扩展为`car`，这个宏不会将`(+ headt foo)`扩展为`(+ cart foo)`
>
> 也不会把`head_door`扩展为`car_door`

宏系统需要知道哪些是token

## Parenthsization

在c/c++的宏系统中定义如下宏

```c++
#define ADD(x,y) x+y
```

在实际使用时会有优先级问题比如：

`ADD(1,2/3)*4`会被扩展为`1+2/3*4`而不是`(1+2/3)*4`

所有在c/c++中定义宏需要加多余的括号比如

```c++
#define ADD(x,y) ((x)+(y))
```

在racket中由于所有表达式都有括号，所以不会存在优先级问题

## 局部变量

局部变量和宏重名时，可能会shadow宏定义

```
(let ([head 0] [car 1]) head) ;0
(let* ([head 0] [car 1]) head) ;0
```

此时如果定义宏`head`to`car`且宏定义对变量绑定有效，则上述代码会变成下面

```
; head to car宏扩展后
(let ([car 0] [car 1]) car) ;报错，let中无法定义相同的变量
(let* ([car 0] [car 1]) car) ;1和原结果不同
```

可以看出宏和局部变量冲突时带来的影响

> 因此c/c++中传统是将宏定义为全大写，而其余代码则是非全大写的

racket中宏不是简单的替换，会考虑scope问题

# Define-syntax(Racket宏系统)

```
; (my-if foo then bar else baz) -> (if foo bar baz)
(define-syntax my-if
	(syntax-rules (then else)
		[(my-if e1 then e2 else e3) (if e1 e2 e3)]))
```

Syntax:

```
(define-sytanx 宏名称
	(syntax-rules (宏中使用的除了宏名称之外的关键词)
		[(含参数的pattern) (扩展后的pattern)]))
```

**Delay macro**

宏可以用于实现某些函数不能实现的功能，比如delay（接收一个e将其变成一个promise(#f thunk二元组)，同时不调用这个e）。函数无法实现，因为racket中函数的参数是eager eval的

```
(define-syntax my-delay
	(syntax-rules ()
		[(my-delay e) (cons (#f lambda () e))]))
```

## Hygienic Marco

> "卫生"的宏？

```
(define (db1 x) (+ x x))
(define (db1 x) (* 2 x))
```

上述两个函数是等价的，但是下列两个宏是不等价的

```
(define-syntax db1 (syntax-rules () [(db1 x) (+ x x)]))
(define-syntax db1 (syntax-rules () [(db1 x) (* 2 x)]))
```

比如`(db1 (begin (print "hi") 42))`，第一个版本print两个"hi"，第二个版本print一次

> 由于函数的参数是eager eval的，故x都只eval一次
>
> 但是宏扩展后每个x都会单独eval，此时若x有副作用，则会有影响

解决方法：把变量保存到局部变量

例子

```
(define-syntax db1
	(syntax-rules ()
		[(db1 x) (let ([y x] (+ y y)))]))
```

> 同时还可以解决宏中变量eval顺序与扩展后不一样的问题

> 在c/c++宏系统中，在宏中定义局部变量是不明智的，需要取如`__name`的变量名来避免冲突，类似[局部变量](#局部变量)中描述的冲突
>
> Racket中hygiene保证了局部变量不会冲突
>
> Racket中的宏有类似lexical scope的机制

Hygienic宏系统定义

1. 会自动重命名宏定义中的局部变量防止冲突
2. 在宏定义时的环境中查找变量(lexical scope)

> 简单的替换(naive expansion)不具备以上性质
>
> 在绝大多数情况下，清洁的宏系统都更好

# Addtitions

## map

[4.10 Pairs and Lists (racket-lang.org)](https://docs.racket-lang.org/reference/pairs.html#(def._((lib._racket%2Fprivate%2Fmap..rkt)._map)))

```
(map proc lst ...+) → list?
 proc : procedure?
 lst : list?
```

Applies *proc* to the elements of the *lst*s from the first elements to the last. The *proc* argument must accept the same number of arguments as the number of supplied *lst*s, and all *lst*s must have the same number of elements. The result is a list containing each result of *proc* in order.

```
> (map (lambda (number)
         (+ 1 number))
       '(1 2 3 4))
'(2 3 4 5)

> (map (lambda (number1 number2)
         (+ number1 number2))
       '(1 2 3 4)
       '(10 100 1000 10000))
'(11 102 1003 10004)
```

## string-append

```
(string-append str ...) → string?
str : string?
```

Returns a new mutable string that is as long as the sum of the given *str*s’ lengths, and that contains the concatenated characters of the given *str*s. If no *str*s are provided, the result is a zero-length string.

```
> (string-append "Apple" "Banana")
"AppleBanana"
```

## remainder

> x % y

```
(remainder n m) → integer?
n : integer?
m : integer?
```

```
> (remainder 10 3)
1

> (remainder -10.0 3)
-1.0

> (remainder 10.0 -3)
1.0

> (remainder -10 -3)
-1
```

## list-tail

```
(list-tail lst pos) → any/c
  lst : any/c
  pos : exact-nonnegative-integer?
```

Returns the list after the first *pos* elements of *lst*. If the list has fewer than *pos* elements, then the [exn:fail:contract](https://docs.racket-lang.org/reference/exns.html#(def._((lib._racket%2Fprivate%2Fbase..rkt)._exn~3afail~3acontract))) exception is raised.

The *lst* argument need not actually be a list; *lst* must merely start with a chain of at least *pos* pairs.

This function takes time proportional to *pos*.

```
> (list-tail (list 1 2 3 4 5) 2)
'(3 4 5)

> (list-tail (cons 1 2) 1)
2

> (list-tail (cons 1 2) 2)
list-tail: index reaches a non-pair
  index: 2
  in: '(1 . 2)

> (list-tail 'not-a-pair 0)
'not-a-pair
```

