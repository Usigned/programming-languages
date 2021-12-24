# OOP vs Functional Decomposition

- functional (and procedural) programming将程序分成不同功能的函数(functions)
- OOP将程序拆分为不同类型的数据(classes)

> 两种方法好似对同一个矩阵的两种视角

Example:

- 有不同的表达式 ints, addtions..
- 有不同的操作: eval, toString...

| data\function | eval | toString | hasZero | ...  |
| ------------- | ---- | -------- | ------- | ---- |
| **Int**       |      |          |         |      |
| **Add**       |      |          |         |      |
| **Negate**    |      |          |         |      |
| ...           |      |          |         |      |

无论何种编程，我们都相当于在填表格，为每个格子填上合适的逻辑

函数式、OOP倡导不同的填表顺序

- 函数式：一个函数对应一列（一个操作）
- OOP：一个类对应一个行（一类数据）

SML例子

```
fun toString e =
	case e of
		Int i => Int.toString i |
		Negate e => "-(" ^ (toString e) ^ ")" |
		Add (e1, e2) => "(" ^ (toString e1) ^ "+" (toSting e2) ^ ")"
```

- 按函数组织，每个函数负责对于**所有数据类型的一种操作**

Ruby例子

```ruby
class Int < Value
    attr_reader :i
    def initialize i
        @i = i
    end
    def eval
        self
    end
    def toString
        @i.to_s
    end
    def hasZero
        i = 0
    end
end
```

- 按数据类型组织，每个类负责**一个数据类型的所有操作**

## 可扩展性

>  向程序中添加操作或数据类型

在不提前考虑扩展性的情况下

- 函数式分解：容易添加操作，而不容易添加数据类型
- OOP：不容易添加操作，而容易添加数据类型

> 容易：直接添加一个新函数，之前代码中的函数或类不用修改
>
> 不容易：之前代码要修改

> 在提取考虑扩展性问题的情况下，二者都可以通过某种方法增加另一方面的扩展性
>
> 1. 函数式：将函数作为类型构造器的参数
> 2. OOP：Visitor Pattern

**Thoughts on Extensibility**

- 使软件可以扩展是宝贵的也是困难的
  - 如果需要新操作，使用FP
  - 如果需要新类型，使用 OOP
  - 如果都需要？Scala等语言中尝试过，这是个难题
  - 事实：通常情况下，未来是很难预测的！
- 可扩展性是双刃剑
  - 代码在不用改变的情况下，未来可能有更多的复用
  - 但是会让原始代码更难理解
  - 通常语言机制会减少代码的扩展性
    - java中的`final`防止重载
    - ML的模块系统中会隐藏一些数据类型

# 如何实现Binary Methods

例子：实现`Int/String/Rational`间相加

| +            | Int  | String | Rational |
| ------------ | ---- | ------ | -------- |
| **Int**      |      |        |          |
| **String**   |      |        |          |
| **Rational** |      |        |          |

## 函数式实现

实现加法函数，枚举每一种可能情况

```SML
fun add_values (v1, v2) =
	case (v1, v2) of
		(Int i, Int j) => Int (i + j) |
		(Int i, String s) => String(Int.toString i ^ s) |
		(Int i, Rational(j, k)) => Rational(i * k + j, k) |
		(String s, Int i) => String(s ^ Int.toString i) | (* not commutative *)
		(String s1, String s2) => String(s1 ^ s2) |
		(String s, Rational(i, j)) => String(s ^ Int.toString i ^ "/" Int.toString j) |
		(Rational _, Int _) => add_values(v2, v1) | (* commutative *)
		(Rational(i, j), String s) => String(Int.toString i ^ "/" Int.toString j ^ s) |
		(Rational(i1, j1), Rational(i2, j2)) => Rational(i1 * j2 + i2 * j1, j1 * j2) |
		_ => raise BadResult "not a value"
```

- 枚举九种情况
- 其中有些可以通过颠倒参数来实现代码复用(commutative)
- 函数式实现比oop实现要更直接，容易理解

## OOP实现

>  oop中实现binary method，比函数式的实现更复杂，更难理解

```ruby
class Int < Value
    attr_reader :i
    def add_values v
    	# 此处实现 Int和各种类型相加
    end
end
```

**naive方式**

```ruby
def add_values v
    if v.is_a? Int
    	# Int + Int branch...
    elsif v.is_a? MyRational
        # Int + Ration branch
    else
        # Int + String branch
    end
end
```

- 不够OOP，一半OOP，一半函数式

>  丑陋，不够优雅，基本上属于函数式的思想

**full oop**

> 如何在不知道类型的情况下调用对应类型的方法

### double-dispatch （visitor pattern）

> 补充阅读：
>
> [也谈double dispatch(双分派)::Visitor 模式 - k_eckel's mindview - 博客园 (cnblogs.com)](https://www.cnblogs.com/k-eckel/articles/205627.html)
>
> [Double Dispatch讲解与实例-面试题 - 霍旭东 - 博客园 (cnblogs.com)](https://www.cnblogs.com/HQFZ/p/4942561.html)

以下示例中应该展示的是

使用Visitor设计模型，在单分语言中实现双分功能

```ruby
class Int < Value
    # other methods & fields
	def add_values v # first dispatch
        v.addInt self # 不给self发信息，相反将self作为addInt的信息发给v
    end
    def addInt v # second dispatch
        # Int + Int 
    end
    def addString v # second dispatch
        # Int + String
    end
    def addRational v # second dispatch
        # Int + Rational
    end
end
```

- 首先通过`self`中的`add_values`方法dynamic dispatch来获取`self`的类型信息
- 之后通过`v`的dynamic dispatch来获取`v`中对应的操作

#### 静态类型中的double dispatch

```java
abstract class Value extends Exp {
    abstract Value add_values(Value other); // first dispatch
    abstract Value add(Int other); // second dispatch
    abstract Value add(MyString other); // second dispatch
    abstract Value add(Rational other); // second dispatch
}

class Int extends Value {
    public Value add_values(Value v) {
        //在编译时就确定了this的类型是Int，该方法会调用Int参数的方法
        return v.add(this); 
    }
    public Value add(Int v) {
        // Int + Int
    }
    public Value add(MyString v) {
        // Int + String
    }
    public Value add(MyRational v) {
        // Int + Rational
    }
    
    public static void main(String[] args) {
    	Value i_value = new Int(123);
        Value s_value = new MyString("hello");
        System.out.println(i_value.add_values(s_value));
    }
}
```

### multimethods(multiple dispatch)

支持multimethod的语言可以不用手动实现double dispatch

- ruby/java都不支持

```java
class Int extends Value {
    public Value add_values(Int v) {
        // Int + Int
    }
    public Value add_values(MyString v) {
        // Int + String
    }
    public Value add_values(MyRational v) {
        // Int + MyRational
    }
}

// java中是无法进行以下操作的，因为java支持的是重载，而不是multimethods
Value a = new Int(123);
Value b = new MyString("hello");
a.add_values(b);
```

基本思想

- 允许多个方法有相同名称
- 通过参数类型区分
- 使用dynamic dispatch来**决定不仅消息接收者的类型，同时还有消息(参数)的类型**
  - `rec.call(msg)`中`rec`和`msg`的类型都动态决定

- 有时候无法决定调用那个方法
- 和`java/c#`中的静态重载不同
  - 消息接收者类型：dynamic dispatch
  - 参数类型：使用**静态类型**来选择方法

# 多继承

三种处理多继承的方法

- 多继承 

  - allow > 1 superclass
  - 引发语法问题：钻石继承等
  - 代表：c++

- mixins 

  - 1 superclass; > 1 method providers
  - mixin：一些**方法**的一个集合
    - 添加一个mixin就相当于向类中添加一些方法
    - just a collection of methods，无法实例化
  - 代表：ruby

- interface 

  - allow > 1 types
  - 代表：静态类型oop语言，java
    - OOP语言的静态检查一般是为了防止调用不存在的方法

  - subclass/subtype
    - 若C是D的subclass，那么C也是D的subtype
    - 任何接收D类型为参数的方法，也可以接收C类型对象做参数
  - Interface目的是使类型系统更加灵活
    - 仅此而已
    - 只会存在于不允许多继承的静态类型语言中

> class专指类
>
> type类型指对象/变量，比如一个对象的类型为Integer，一个变量的类型为int

# Abstract Methods

存在目的：通常一个父类会想要（需要）所有子类都重写一些方法

- 动态类型语言中可以直接实现，如果未实现则在运行时抛出异常
- 静态类型语言，为了通过类型检查则
  - 需要一个假方法，在调用时抛出异常
  - 或者提供一个抽象方法强制要求子类实现

> 某种程度上看，抽象类和高级函数有类似之处

# Sum up

1. 什么是dynamic dispatch？

   个人理解

   ```java
   class A {
   	public void m() { return 1;}
   }
   
   class B extends A {
   	public void m() { return 2;}
   }
   class Test {
       public static void main(String[] args) {
           A instance = new B();
           instance.m();
       }
   }
   ```

   ~~其中引用类型为A的instance在调用m时会返回2而不是1，这便是dynamic dispatch~~

   2021-12-24 修正

   上述理解一定是错误的，dynamic dispatch应该使所有OOP语言的共性，无论有没有类型系统，而上述理解直接限制了语言一定有类型系统，故其一定错误。

2. 什么是double dispatch?

   字面意思：double dispatch => 两次dynamic dispatch

   其反应在实现binary method的代码中为（以下代码为[binary method](#静态类型中的double dispatch)中的复制）

   ```java
   abstract class Value extends Exp {
       abstract Value add_values(Value other); // first dispatch
       abstract Value add(Int other); // second dispatch
       abstract Value add(MyString other); // second dispatch
       abstract Value add(Rational other); // second dispatch
   }
   
   class Int extends Value {
       public Value add_values(Value v) {
           //在编译时就确定了this的类型是Int，该方法会调用Int参数的方法
           return v.add(this); 
       }
       public Value add(Int v) {
           // Int + Int
       }
       public Value add(MyString v) {
           // Int + String
       }
       public Value add(MyRational v) {
           // Int + Rational
       }
       
       public static void main(String[] args) {
       	Value i_value = new Int(123);
           Value s_value = new MyString("hello");
           System.out.println(i_value.add_values(s_value));
       }
   }
   ```
   
   1. 第一次dynamic dispatch是在变量调用自己的`add_values`方法时，其调用的是`Int`中的方法而不是`Value`中的方法
   2. 第二次dynamic dispatch则是在`add_values`方法内部，`v`变量调用自身的`add`方法而不是传入时`v`的类型`Value`中的方法

3. multiple dispatch (multimethods)

   语言在调用方法时，除了对象会dynamic dispatch，其参数也会dynamic dispatch，故在这些语言中无需手动实现double dispatch。

   > double dispatch可以理解为显式的编码，在不支持多分的语言中实现多分。
