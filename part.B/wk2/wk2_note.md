# Racket中定义数据类型

racket中没有one-of类型，因为不需要

- 可以通过`number?/string?/...`等方法判断变量类型
- 且可以通过cons来组合不同的类型(racket中的List可以有不同类型的元素)

> 在SML中组合不同的数据类型需要自己定义数据类型
>
> 如`datatype int-and-string = I of int | S of string`
>
> 其中`I/S`是类似标签的存在
>
> 在racket中，每个变量在声明时就相当于自带了一个标签，故不需要用one-of类型来组合不同类型的变量，同时也解释了racket中的List为什么可以存不同类型的变量
>
> 其方法应该时反射？


## Struct

```
(struct foo (bar baz quux) #:transparent)
; 申明一个foo类型，其有三个field: bar baz quux

(foo e1 e2 e3)
; 返回一个foo其中bar=e1,baz=e2,quux=e3

(foo? e)
>#t

; 以下函数只有在e是通过foo构造函数生成的变量时才能正常使用，否则会error
(foo-bar e)
>e1

(foo-baz e)
>e2

(foo-quux e)
>e3
```

- 类似SML中的record，不过还附带data-extraction函数

- `struct`基本和SMl中的构造器相同，不过racket中是函数而不是pattern-matching

- `#:transparent`：可选属性，能够让struct在repl中更好的显示

- `#:mutable`：有更多的函数

  ```
  (struct card (suit rank) #:transparent #:mutable)
  ;同时提供 set-card-suit! set-card-rank!方法
  ```
  

> 使用structs相比于自定义list和helper function
>
> - 更容易
> - 更严谨的检查
> - 更模块化：可以限制外界访问等等
>
> struct在racket中是一个独立的概念，其无法用函数、宏等实现
>
> - 函数无法一次引入多个binding
> - 函数和宏都不能创建新的类型
>   - 指`number?/pair?/...`等类型判断函数能返回`#t`

# Symbol

```
'SymbolName

(define mySymbol 'theSymbolName)
(eq? mySymbol 'theSymbolName)
>#t
```

- 类似string
- 可以用`eq?`快速地比较
  - string比较就相对较慢

# 编程语言实现

基本工作流：

![image-20211127190639955](https://raw.githubusercontent.com/Usigned/pic-typora/main/images/image-20211127190639955.png)

- concrete syntax先经过parser转换为AST
- AST再进行类型检查
- 其余部分接受一个AST并执行程序然后产生一个结果

实现PL B的两种基本方式：

- 用A语言实现一个解释器 interpreter
  - 更恰当的名字是: executor/evaluator
  - 接受一个使用B写的程序并产生一个结果

- 使用A语言实现一个编译器，将B程序转化为语言C中的程序（比如二进制语言）
  - 更恰当的名字是: translator
  - 转换过程中必须保证转换前后程序的语义**等价**

> 用来实现B语言的A语言称为元语言 metalanguage
>
> A - 用于实现
>
> B - 被实现

> 现实中的语言一般结合 编译器和解释器两种方式，并且有多层
>
> - java先将java代码编译为字节码
> - 然后使用一个二进制的解释器来执行字节码（对于使用频繁的函数会直接在执行时被编译为二进制）
> - 芯片本身是一个二进制解释器
>   - x86中有些优化操作也涉及将操作指令编译为更底层的指令
>
> racket实现中也是编译器和解释器结合

> 具体的**语言实现 implementation**和**语言本身定义 definition**无关
>
> 故没有所谓的编译型语言或解释型语言 (只有编译型实现或解释型实现)
>
> - 程序无法得知底层实现是如何运作的

## 不使用parser

在PL A中实现PL B，可以通过以下方式跳过parsing

- 直接在PL A中写 AST
- 使用ML或racket中提供的struct
- 在A中将B程序embed为语法树

> 有点类似markdown和html
>
> 不确定md有无parser，个人感觉是没有的

> 作业中需要严格按照定义：
>
> const (int) / bool (b) /... 可以假设输入类型是正确的
>
> 但对于表示式的递归结果则需要检查其类型
>
> add (e1 e2) 需要检查 e1 e2是整形