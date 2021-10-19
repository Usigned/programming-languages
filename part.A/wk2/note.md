如何使用SML

```shell
sml
```

`sml`命令，运行当前目录即程序当前目录，使用`use`导入时需要该相对路径。


---

syntax -- 语法 how to write

senmantics -- 语义 what it mean

- Type-chek
- evaluation

静态环境 - 类型检查

动态环境 - 赋值(evaluate)

Variable Binding -- 绑定？不知道怎么翻译，貌似是变量定义

```
val x = 34
```

首先在静态环境中检查x类型为int，之后在动态环境中给x赋值为34

---

# Expressions properties

1. syntax
   - how to write

2. type-checking rules
   - expression type or fails

3. evaluation rules (used only on things that type-check)
   - produce a value (or exception etc)

> 查看任何表达式时都看这三项属性
>
> - 语法
> - 类型检查规则
> - 赋值规则

**条件(condition)**

- syntax: `if` statement `then` value1 `else` value2
- type-check: value1和value2应该有相同类型，statement应该为bool类型
- evaluation:根据条件表达式值为value1或value2

**变量(variable)**

> 如何使用，比如在表达式中使用变量，而不是如何binding

- syntax: 字母/数字序列
- type-check: 在当前的静态环境中查找其类型，未找到则失败
- evaluation: 在当前动态环境中查找

**加法**

- syntax:  `e1 + e2` 其中`e1`和`e2`也是表达式

- type-check

  如果`e1`和`e2`的类型是int

  则`e1+e2`的类型也为int

  否则not type-check

- evaluation

  如果`e1`、`e2`的值分别为`v1`/`v2`

  那么`e1+e2`的值为`v1`和`v2`的和

**值(values)**

- 所有values都是表达式(expression)
- 非所有expressions都是values

- 每个value在初始阶段都在动态环境中赋值给自己

- examples:
  - 34, 17,42 -> int
  - true/false -> bool
  - () -> unit

**等于(判断)**

- a `=` b
- 

# 赋值

```
val a = 1
val b = a (* b is bound to 1 *)
val a = 2
```

Reasons

1. expressions in variable bindings are evaluated **eagerly**
   - before the variable binding "finishes"
   - afterwards, the expression producing the value is irrelevant
2. no way to "assign to" a variale
   - can only shadow
   - ml中变量都是不可变的，一旦在动态环境中赋值就无法改变，上述表达式第三句会重新创建一个动态环境，并将之前动态环境中的a shadow掉

# 函数

## Binding

- syntax: `fun x0 (x1 : t1, ..., xn :tn) = e`
- evaluation: **a function is a value**
  - add **x0** to env
  - Body不执行
  
- type-check

  - 如果e类型检查通过则添加binding `x0 : (t1 * ... * tn) -> t`  

  - e类型需要和静态环境中的`t`匹配，且只能包含以下内容

    - 静态环境中已经有的binding
    - 参数`x1 : t1, ..., xn :tn`
  - 自己`x0 : (t1 * ... * tn) -> t` (以便递归调用)
  - 

## calls

- syntax:  `e0 (e1, ..., en)`

- type-check

  - `e0`是`(t1 * ... * tn) -> t`形式的
  - `e1, ..., en`是`t1 * ... * tn`类型的

  - 如果上述两点通过则检查`e0 (e1, ..., en)`是t类型的

# REPL

sml就是repl，文件只是使用repl的一种方法。
