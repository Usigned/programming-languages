> Ruby basic

ruby是纯OOP语言，包括数字的基本类型都是变量

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

> ~~作用有点类似于在build-in函数中列举变量~~
>
> 应该是添加的意思详见[动态类型定义](#动态类型定义)

```ruby
attr_accessor :arg, :param, :hello
private_class_method :new, :initialize
```

# Data Model in Ruby

## 万物皆对象，所有操作皆方法调用

> every thing is object, every operation is method call

- 所有值都是对象引用

- 所用对对象的操作都是调用对象的方法

  ```ruby
  3 + 4
  #其实也是方法的语法糖
  #方法名是+
  3.+(4)
  ```

- `nil`也是**对象**
  - 和java中的`null`不一样，`null`不是对象
  - 用于表示没有数据
  - `nil`中也包括一些方法
    - `nil.nil?`
  - `nil`和`false`等价

- 所有定义的方法都是类的一部分
- Top-level methods会被加入到`Object`类中
  - `Object`是所有类的父类
  - 故Top-level methods会加入到所有类中（前提不被覆盖）

> 在irb输入`self.class`会返回`Object`

## 反射

所有对象都有类似以下的方法

- `methods`
  - 对象有哪些方法
- `class`
  - 对象是什么类的

> 反射：运行时查询程序的状态如：对象类型、有哪些方法

```
3.class
=> Integer
3.methods - nil.methods
=> .... [Integer has, nil doesn't]
3.class
=> Class
3.class.Class
=> Class
```

## 动态类型定义

运行时改变class的定义

- 直接定义一个相同名称的类并且改变其结构

- 在类型定义改变后，所有该类型的对象也将改变，就算是之前定义的
  - 通过反射实现

```
a = 3
# 向Integer类中动态加入一个方法double
class Integer
 	def double
		self + self
	end
end
=> :double #返回值是这个，说明:应该指明添加的意思
a.double #现在之前定义的a也有double方法了

# 覆盖了Integer中原有的+
class Integer
	def + x
		self * x
  end
end
```

> 许多oop语言中是没有这个特性的
>
> 这些动态特性容易引起语义问题

# 鸭子类型
