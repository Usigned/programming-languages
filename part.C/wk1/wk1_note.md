> Ruby basic

ruby是纯OOP语言，包括数字的基本类型都是变量

[ruby官网](http://www.ruby-lang.org/en/)

# 运行

运行`.rb`文件

```shell
ruby fileName.rb
```

交互式环境 iteracitve ruby

```shell
irb
> load "fileName.rb" #加载文件
```

# 定义Class

```ruby
class ClassName
  def methodNameA methodArg
    expression
  end
  
  def methodNameB (x, y)
    methodNameA x
end
```

- 每个方法和整个类定义结束时需要添加`end`
- 方法参数只能有一个
  - 通过元组传递多个参数
- 使用`self`指向自身，和java中作用基本一样
- 默认返回值为最后一个experssion结果
  - 而不是nil

> 基本语法和python很像

# 创建对象&使用方法

```ruby
# 创建对象
a = ClassName.new
#调用方法
a.methodNameA 1
a.methodNameA(1)
a.methodNameB(1, 2)
a.methodNameB (1, 2) #报错，不能有空格
a.methodNameB 1 #报错
```

- 基本原则：别考虑curry什么的，直接使用python风格调用

> 猜测ruby类中的方法参数不是一个tuple，而是多个参数

# 对象属性

使用`@`来读取对象属性(filed的值，如果属性不存在则返回`nil`

```ruby
# 向A中添加一个foo字段
class A
  def initialize(f=0)
    @foo = f
  end
  
  def m1
    @foo += 1
  end
  
  def foo
    @foo
  end
end
```

# 类属性&方法

- `@@`定义类属性
- `self.methodName`定义类方法
- **大写开头**的类常量
  - 可以被外界访问(public)，类属性、对象属性则是private的
  - 不能被改变
  - 通过`ClassName::InstanceName`访问

```ruby
class A
  Instance = 123
  def self.public (args) #类方法public
    @@args = args #类属性args
  end
  
  def self.args
    @@args
  end
end

A::Instance
A.public 1
A.args
```

# 可见性

## 变量

Ruby中instance var总是private

- 只能由对象自己使用

- `e.@foo`是不行的

- 需要实现`get/set`方法来访问instance var

> Getter/setter语法糖
>
> ```ruby
> # getter
> def foo
> 	@foo
> end
> 
> # setter
> def foo= x
> 	@foo = x
> end
> 
> #调用setter时可以加个空格
> e.foo = 42 #调用setter
> #使用attr_read, attr_accessor提供getter/setter
> attr_reader :name, :bar
> attr_accessor :name, :bar
> ```

## 方法

- private: object
- protected：same class & subclasses
- public 默认的

```ruby
class Foo
  protected
  # protected method
  public
  ...
  private
  ...
end
```

> Ruby中代码有严格顺序要求
>
> 例子1
>
> ```ruby
> 
> class Singleton
>     
>     def initialize
>         @args = 123
>     end
> 
>     Instance = Singleton.new #写在intialize后面，否则args=nil
>     attr_accessor :args
> 
>     #注意位置，new设为private从这行开始生效
>     private_class_method :new
> 
> end
> ```
>
> 如果将`private_class_method`放到代码开头，那么Instance就无法适用`Singleton.new` 了，因为`new`只能由object自己调用（失去意义）
>
> 例子2
>
> ```ruby
> class A
> 
>     StatiInstance = A.new
>     
>     def initialize(arg)
>         @arg = arg
>         @param = StatiInstance
>         @good = 1
>     end
> 
>     attr_reader :arg
>     attr_accessor :param, :good
>     
> end
> ```
>
> 由于`initialize`定义于`StaticInstance`后，故若试图给`StatiInstance = A.new`加上参数，则会报错，提示`A.new`接受0个参数
>
> - ruby中的条件、函数、类都以`end`结尾，没有`:`
> - ruby中的`:`有特殊的用处`attr_accessor :param, :good`

# Summary

ruby class中的变量

- object var: `@arg`

  - private
  - 访问方法：自定义函数或`attr_reader/attr_accessor :arg, :param` 

- class var: `@@arg`

  - private
  - 访问方法: 自定义函数`def self.funcName(args)`

- class常量

  - public
  - 名称必须大写开头
  - 访问方法`ClassName::Instance`

冒号用法

> 作用有点类似于在build-in函数中列举变量

```ruby
attr_accessor :arg, :param, :hello
private_class_method :new, :initialize
```

# Arrays

> 类似python中的List

变长，可以存储不同类型对象

**和python/list的相同点**

- 基本和Python一样 `[1,2,3,4,5,True,"hello"]`

- 和python一样有`a[-1]`表示倒数第一个
- 都可以切片，但语法不同

**和python/list的不同点**

- 可以向任意位置赋值`a[100]`
  - 会自动扩展，并将空位填上`nil`

- 切片的语法`a[0,5]`
  - **从0号开始，获取5个元素**

> 总结，大体上和python list一样

# Blocks

> 很像java中的stream + lambda
>
> 类似一个callback

基本上是一个含闭包的匿名函数

例子

```ruby
3.times {puts "hello"}
```

- `3.times`会返回一个`#<Enumerator: 3:times>`
- 每个方法调用可以用0个或1个block
  - 不能有多个

**sytanx**

```ruby
i = 2
[4,5,6].each {|x| i.times {puts(x * x)} } #每个数字print平方 2次
```

- { }或`do end`
- 参数`|param1, param2, param3|`

- 有lexical scope

> block相当于函数参数，和方法参数独立
>
> `methodCall(params) {blocks}`
>
> 在标准库中广泛使用

**Arrays常用方法**

 - `new(5) {|x| 4 * (x + 1)}`
 - `each` 

 - `all?/any?`
 - `map/collect`
 - `select` 相当于`filter`
 - `inject(aux) {#add func}` 相当于`reduce`

## 定义含block的方法

```ruby
def silly a
	(yield a) + (yield 42)
end

silly(5){ |b| b*2}
```

- 没有额外的block定义
- `yield`关键字来使用block中方法
- 此时调用者没使用block则会报错

## Proc

ruby中的block是二等公民(second-class)

> 一等公民：指可以当作表达式的值
>
> 二等公民：无法当作表达式的值

将block封装为一等公民Proc

- 语法：`lambda {#block}`

```ruby
a.map {|x| lamdba {|y| x >= y}}
```

# Duck Typing

> "If it walks like a duck and quacks like a duck, it's a duck"

动态类型的面向对象语言的一种风格

- ruby和python都是鸭子类型

好处

- 更灵活
- 更多复用

坏处

- 破坏了代码封装性
- 用户会过于依赖于代码的细节

# Hashes

> python中的dict

哈希表

- 无序
- k/v可以是任何值

语法

> 基本和python一样

```
h1 = {"a"=>"b", "c"=>"d"}
```

# Ranges

> python中range
>
> 类似生成器

语法

```ruby
1..1000
```

# 继承

```ruby
class ColorPoint < Point ...
```

- 默认继承至`Object`

- 继承所有方法，并可以覆盖

**检查superclass**

```ruby
ColorPoint.superclass
=> Point
ColorPoint.new is_a? Point
=> True
ColorPoint.new instance_of? Point
=>False
```

使用这些反射方法通常不是OOP风格

- 放弃了如鸭子类型等优势

> java中的`instanceof`相当于Ruby中的`is_a?`

# 覆盖 & Dynamic Dispatch(动态绑定)

> 覆盖overriding是什么就不解释了

**Object vs Closures**

- object某种程度上可以看作有许多方法的闭包
- object显示保存变量，闭包通过环境来保存变量
- 继承某种程度上只是代码复用
- 最大区别：
  - **原类中的方法可以使用覆盖后的方法**

```ruby
class Super
    def initialize(x, y)
        @x = x
        @y = y
    end
    attr_accessor :x, :y
    def dist
        Math.sqrt(x * x + y * y) #调用了类中提供的x y方法
    end
end

class Sub
    def initialize(r, theta)
        @r = r
        @theta = theta
    end
    #override
    def x
        @r * Math.cos(@theta)
    end
    #override
    def y
        @r * Math.sin(@theta)
    end
    #dist方法不用覆盖，且能正常运行
    #因为其会调用子类中已覆盖的方法
    #动态绑定
end
```

## 动态绑定

> oop中最独特的特点

- 又称延迟绑定
- 在类`C`的`m1`方法中调用`self.m2()`可以会调用`C`子类中的`m2`方法

> 故需要在语义中定义**查找方法**
>
> 更具体一点：什么是self

## what's self

- 指向当前对象

- 实例变量`@x`通过指向`self`的对象查找
- 类变量`@@x`通过`self.class`的对象查找
- look up methods ...

## Ruby method lookup

```ruby
e0.m(e1,...,en)
```

调用方法（又称发送消息）

1. 将`e0,...,en`绑定到`obj0,...objn`

2. 假设`obj0`的类型是`C`
   - `obj0`又称为消息的接收者
3. 从`C`开始查找`m`，若存在则调用代码，否则在`C`的父类中递归查找
   - 若在`Object`中还未找到则会报错

4. 运行方法体
   - 参数绑定为`obj1, ..., objn**`**
   - **`self`绑定为`obj0`，该步实现动态绑定**

例子

```ruby
class A
    def m
        n
    end
    def n
        42
    end
end

class B < A
    def n
        m
    end
end

B.new.m
```

按照上述规则

1. 将`B.new`绑定为`obj0`
2. 查找`m`方法，会在`class A`中找到定义，其为

```ruby
def m
	n
end
```

3. 执行时

   - 将`self`绑定为`obj0`

   - 此时`self`为一个`B`对象
   - 执行代码，其中`n`会调用`self.n`，即`class B`中的`n`方法
   - 其又会调用`m`方法，故程序会死循环

> 整体看下来，对象方法调用类似于一个受限范围内的dynamic scope

> 部分静态类型的OOP语言支持重载（函数签名包括参数列表）
>
> 在方法查找时需要借助类型检查器的帮助
>
> 由于需要借助类型检查，动态类型中的重载是没有意义的（或很难实现的）

## dynamic dispatch vs closure

- 动态绑定中父类的方法的行为有可能被子类改变（覆盖）
- 闭包的行为则定义后变不会改变，因为其环境是定义是环境

trade-offs

- 增加了灵活性，同时也让代码更难理解
- 有时需要防止覆盖
  - `private`或`final`

- 子类能更容易改变行为，而不用复制代码
  - more code reuse?

> closure和object是不一样的，最大的不同点在于动态绑定
