class A
    Instance = 123
    
    def initialize
        @arg = 2
    end
    
    def m
        puts Instance
        puts @arg
        # n
        # 此处n会调用B中的n，造成死循环
    end

    def n
        2
    end
end

class B < A
    Instance = 456

    def initialize
        @arg = 1
    end

    def n
        m
    end
end