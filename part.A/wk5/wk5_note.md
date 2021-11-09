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

