# Type System

## pseudo language

- Record - mutable

  - create `{f1=e1, f2=e2,..., fn=en}`
  - access `e.f`
  - update `e1.f = e2`

- Basic Type System

  - `{f1:t1, f2:t2, ..., fn:tn}`

  - rules:

    1. 如果`e1`类型为`t1`，...，`e2`的类型为`tn`
       - 则`{f1=e1, ..., fn=en}`类型为`{f1:t1, ..., fn:tn}`

    2. 如果`e`是一个record且包含类型`f:t`
       - 则`e.f`的类型为`t`
    3. 如果`e1`一个record包含类型`f:t`，同时`e2`的类型为`t`
       - 则`e1.f = e2`的类型为`t`

- example

  ```
  fun distToOrigin (p:{x:real,y:real}) = Math.sqrt(p.x*p.x + p.y*p.y)
  val pythag : {x:real,y:real} = {x=3.0,y=4.0}
  val five : real = distToOrigin(pythag)
  ```

- problem:

  ```
  fun distToOrigin (p:{x:real,y:real}) = Math.sqrt(p.x*p.x + p.y*p.y)
  val c : {x:real,y:real,z:real} = {x=3.0,y=4.0,z=5.0}
  val five : real = distToOrigin(c)
  ```

  - 由于`c`中多了一个字段，虽然其不会影响函数的功能
  - 但根据上述规则，下列程序将不能通过类型检查
  - 我们希望程序能够通过类型检查

## Subtyping

在不改变已有的type规则下，增加subtype

**定义subtyping**

- subtyping表示: `t1 <: t2`如果`t1`是`t2`的一个子类
- 一条新规则：如果`e`的类型为`t1`且`t1 <: t2`
  - 那么`e`的类型也可以视为`t2`

> 定义subtyping规则时，需要注意，不能破坏type system的可靠性

**定义subtyping规则**

原则：如果`t1 <: t2`，那么所有`t1`类型的值都可以用于`t2`类型的地方

- 在上述定义的语言中该规则可以具象化为：所有子类的类型需要有父类全部的filed

**rules**

1. "width" subtyping: 可以从宽record中提出filed的子集作为父类

   > 子类比父类有更多的filed

2. "permutation"：record中filed的顺序不重要
3. 传递性：`t1 <: t2`和`t2 <: t3`可以推出`t1 <: t3`
4. 每个类型都是自己的subtype

**Depth subtyping**

按照上述规则`{center: {x:real, y:real, z:real}, r:real}`不是`{center: {x:real, y:real}, r:real}`的子类型

如果加入一个规则(depth subtyping)：

- 如果`ta <: tb`那么 `{f1:t1,..., f:ta, ..., fn:tn} <: {f1:t1, ..., f:tb, ..., fn:tn}`

此时上述就会通过类型检查，但是这样会**打破类型系统的可靠性**（由于filed是可变的）

> 如果fields是**不可变的**，那么depth subtyping是**可靠的**
>
> - setters, depth subtyping, soundness - 三选二