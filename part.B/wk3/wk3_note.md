# ML vs Racket

Commons

- 都鼓励不可变变量
- 函数都是一等公民
- 函数参数都是eager eval的
- ...

Differences

- syntax
- Pattern-matching vs Struct tests(int?/string?/...)

- **type system**
  - **Static type check vs Dynamic type check**

> 以ML的视角看Rakcet，可以把Racket中的类型看作一个大类型，其中包括所有int/string/bool等类型，struct-test看成pattern-matching
>
> 然而这样无法解释Racket中的struct，即ML中无法向datatype中动态添加属性
>
> ```
> datatype mytype = Int of int | String of string | GOOD
> ```
>
> 无法向`mytype`中动态添加属性
>
> 合理，因为如果可以添加，会影响到pattern-matching检查枚举是否穷尽

# Static checking

> Static checking is anything done to reject a program after it (successfully) parses but before it runs

这是一个十分宽泛的定义

静态检查指在语法检查后程序运行前，根据语言规定阻止部分程序执行的检查。

- 拒绝哪部分程序是语言定义的一部分
  - 静态检查可以有包括检查bug等等功能
- 常见的静态检查是通过**类型系统**实施的
  - 方法是给每个变量一个类型
  - 目的包括
    - 防止基本类型混用 (4/"hi")
    - 增强抽象能力 (ML中的多态)
    - 避免动态(运行时)检查 (避免使用如`int?`等)
    - 避免使用未定义的变量
    - ...

- 动态类型语言（几乎）没有任何静态检查
  - 界限不绝对
  - 比如Racket中会检查变量是否被定义，但几乎无任何其他静态检查，故Racket还是被称为动态类型

## ML中的静态检查

ML中的静态检查保证程序永远不会遇到以下问题

- 基本操作用于错误的类型上
  - 对非数字做算术
  - `e1 e2`而`e1`不是函数
  - `if`判断非bool类型
- 使用未定义的变量
- pattern-match中有冗余的pattern
- 模块外的代码使用不在签名中的方法
- ...

> 前两点属于类型系统的标准方案，但不同的语言的类型系统有不同的标准
>
> - 一个类型系统阻止的行为有可能被其他类型系统允许
>   - 比如ML不会检查数组越界
> - 没有类型系统可以阻止所有错误

> 静态检查/动态检查只是检查时机的问题
>
> - 键入程序时
> - 编译时
> - 链接时
> - 运行时
> - Later：返回一个特殊的符号
>
> 根据经验，编译时、运行时比较适合检查问题