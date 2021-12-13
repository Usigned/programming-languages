class Test
    def test
        34
    end
    
    def test2 x
        puts x
    end

    def test3 (x, y)
        puts y
    end
end


class A
    
    # 类静态常量
    # public
    # 名称一定要大写开头
    StaticInstance = 123

    #attr_accessor: msg, args

    # def initialize
    #     @msg = "Hello World"
    #     @args = 1
    # end

    
    def self.public (args) #类方法public
      @@args = args #类属性args
      return 123
    end
    
    def self.args
      @@args
    end
end


class Singleton
    
    def initialize
        @args = 123
    end

    Instance = Singleton.new #写在intialize后面，否则args=nil
    attr_accessor :args

    #注意位置，new设为private从这行开始生效
    private_class_method :new

end