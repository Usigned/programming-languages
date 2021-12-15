class A

    StatiInstance = A.new

    def initialize(arg)
        @arg = arg
        @param = StatiInstance
        # @@bar = 0
    end

    attr_reader :arg
    attr_accessor :param, :bar

    
end



class RationalA

    def initialize(num, den=1)
        if den == 0
            raise "error"
        elsif den < 0
            @num = -num
            @den = -den
        else
            @num = num
            @den = den
        end
        reduce
    end

    def to_s
        ans = @num.to_s
        if @den != 1
            ans += "/" + @den.to_s
        end
        ans
    end

    def add! r
        @num = r.num * @den + r.den * @num
        @den = r.den * @den
        reduce
    end

    def + r # no mutation
        ans = RationalA.new(@num, @den)
        ans.add! r
    end

private
    def gcd(x, y)
        if x == y
            x
        elsif x < y
            gcd(x, y-x)
        else
            gcd(x-y, x)
        end
    end

    def reduce
        if @num == 0
            @den = 1
        else
            d = gcd(@num.abs, @den)
            @num /= d
            @den /= d
        end
        self
    end

protected
    attr_reader :num, :den

end