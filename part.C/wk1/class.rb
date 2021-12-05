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
    Instance = 123
    def self.public (args) #类方法public
      @@args = args #类属性args
      return 123
    end
    
    def self.args
      @@args
    end
end