如何使用SML

```shell
sml
```

`sml`命令，运行当前目录即程序当前目录，使用`use`导入时需要该相对路径。


---

syntax -- 语法

senmantics -- 语义
- 程序执行前类型检查（静态环境）
- 运行时动态环境

---

# Expressions properties

1. syntax
   - how to write

2. type-checking rules
   - expression type or fails

3. evaluation rules (used only on things that type-check)
   - produce a value (or exception etc)

**变量(variable)**

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

- 每个value在初始阶段都赋值给自己

- examples:
  - 34, 17,42 -> int
  - true/false -> bool
  - () -> unit

# 赋值

```
val a = 1
val b = a (* b is bound to 1 *)
val a = 2
```

Reasons

1. expressions in variable bindings are evaluated eagerly
   - before the variable binding "finishes"
   - afterwards, the expression producing the value is irrelevant
2. no way to "assign to" a variale
   - can only shadow

# 函数

## Binding

- syntax: `fun x0 (x1 : t1, ..., xn :tn) = e`
- evaluation: **a function is a value**
  - add **x0** to env

- type-check

  - 如果e类型检查通过则添加binding `x0 : (t1 * ... * tn) -> t`  

  - e类型需要和静态环境中的`t`匹配，且只能包含以下内容

    - 静态环境中已经有的binding
    - 参数`x1 : t1, ..., xn :tn`

    - 自己`x0 : (t1 * ... * tn) -> t` (以便递归调用)

## calls

- syntax:  `e0 (e1, ..., en)`

- type-check

  - `e0`是`(t1 * ... * tn) -> t`形式的
  - `e1, ..., en`是`t1 * ... * tn`类型的

  - 如果上述两点通过则检查`e0 (e1, ..., en)`是t类型的
