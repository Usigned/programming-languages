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

# Java中的subtyping

```java
class Point {}

class ColorPoint extends Point {
  int color = 1;
}

class Test {
  static void set(Point[] ps) {
    ps[0] = new Point(); // can throw exception
  }
  
  public static void main(String[] args) {
    ColorPoint[] cps = new ColorPoint[10];
    set(cps); //不合适的depth subtyping
    ColorPoint cp = cps[0]; //运行时不会出错
    c.color; //运行时不会出错
  }
}
```

程序

1. 声明两个类`Point`和`ColorPoint`，且`ColorPoint <: Point`

2. 创建一个方法`set`，且接受一个`Point`数组，并将其中一个元素赋值

3. 新建一个`ColorPoint`的数组，并用其调用`set`方法

结果：上述程序**可以通过类型检查**，但是会在运行时抛出异常`ArrayStoreException`

这里属于Java中的**Depth Subtyping**，由于数组是可变的，同时又要保证类型系统的可靠性，故Java选择抛出运行时异常

1. java中数组的读取不会出现问题
   - 若`e1`类型为`t[]`，那么`e1[e2]`永远会返回`t`的子类

2. java中赋值可能出现问题
   - `e1[e2] = e3`可能失败，即使`e1`类型为`t[]`，`e3`类型为`t`
   - 运行时检查数组元素的类型，并且不允许存子类型
   - 没有类型系统的支持

## null

null本意应该表示没有字段的数据，按照"width" subtyping的原则，其应该是所有类型的父类型

- 然而在Java中null是所有类型的子类型，即可以`String s = null;`

- 这样设计有时可以带来方便，但是同样会没有类型系统静态检查的支持

  > 所以java程序员会经常遇到null指针异常
# Function Subtyping

> 1. subtype has more fields.
> 2. you can require less and return more.

1. 返回值

   如果`ta <: tb`，那么`t->ta <: t->tb`

   - `t->ta`函数会比`t->tb`函数返回更多的fields

2. 参数

   > 不能允许以下规则
   >
   > - 如果`ta <: tb`，那么`ta->t <: tb->t`，应该子函数需求了更多的fields

   如果`tb <: ta`，那么`ta->t <: tb->t`

   - 子函数`ta->t`比父函数`tb->t`需求更少的fields

3. 综合

   如果`t3 <: t1`且`t2 <: t4`

   - 那么`t1->t2 <: t3->t4`

   > require less, return more

# OOP Subtyping

OOP语言中

- 一般使用class名称作为type名称
- subclass同时也是subtype
- 替换原则：subclass的实例可以被用于superclass的地方

> 这样引入了一些限制：如果一个类Subclass其具有Superclass所有的field，但是其没有显式的继承Superclass，从类型系统角度上来讲，将Subclass视为Superclass的子类是可以的，但在一般的OOP语言中则要求Subclass要显示的继承Superclass，才能将其视为子类型。

**Actual Java**

- 类型是class名，同时subtyping是显式的subclass
- subclass能够添加fields和methods
- 如果`ta <: tb`，那么subclass能够通过定义`t->ta`覆盖方法`t->tb`
  - 但无法通过`tb->t`来覆盖方法`ta->t`，相反其会触发静态重载从而声明一个相同名称的不同方法
  - 导致subtyping规则更加严格（是原规中的一个子集）

**Example**

```java
class SuperClass {
    public SuperClass get(SuperClass s) {
        return null;
    }
}

class SubClass extends SuperClass {

    // Override
    public SubClass get(SuperClass s) {
        return null;
    }

    // OverLoad
    public SuperClass get(SubClass subClass) {
        return null;
    }
}
```

# Generics vs Subtyping

##  **Generics**

type variables, parametric polymorphism

- 通用函数

  ```
  fun compose (g, h) = fn x => g (h x)
  (* compose : ('b -> 'c) * ('a -> 'b) -> ('a -> 'c))
  ```

- generic collections

  ```
  val length : 'a list -> int
  val map : ('a -> 'b) -> 'a list -> 'b list
  val swap : ('a * 'b) -> ('b * 'a)
  ```

- many other idioms

- 一般使用场景：当类型可能是**任意类型**，但是多个类型需要是**同一类型**。

> 使用subtyping在containers中是非常不方便
>
> - 一般需要使用Object + 很多向下转型

## Subtyping

subtype polymorphism

- 代码中需要类型Foo，但是也可以提供比Foo更多的信息
  - 比如ColorPoint和Point
- GUI中经常会用到

## Bounded Polymorphism

generic和subtyping结合：使用subtyping来限制generic的多态

- 用例：任何是`T1`子类型的类型，任何可比较的类型...
- bounded polymorphism

**Example**

```java
List<Point> inCircle(List<Point> pts, Point center, double r) { ... }
```

- 上述方法无法处理`List<ColorPoint>`

- **因为`List<ColorPoint>`不是`List<Point>`的子类型**
  - **depth subtyping是不可靠的！**

1. 使用泛型

   ```java
   List<T> inCircle(List<T> pts, Point center, double r) {...}
   ```

   - 此时`inCircle`方法能处理`List<ColorPoint>`
   - 但其方法体无法合理的实现，因为对`T`的类型没有任何限制

2. Bounds

   ```java
   List<T> inCircle(List<T> pts, Point center, double r) //where T <: Point
   {...}
   ```

   - 添加限制：`T <: Point`
   - java syntax

   ```java
   <T extends Point> List<T> inCircle(List<T> pts, Point center, double r) {...}
   ```

   

