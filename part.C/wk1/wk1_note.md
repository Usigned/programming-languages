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

