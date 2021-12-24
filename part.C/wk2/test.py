class A:
    i = 1
    def m(self):
        print(self.i)
        self.n()
        self.k()

    def n(self):
        print(self.i)
        print("method n() in A")
        
class B(A):
    i = 2
    def n(self):
        print(self.i)
        print("method n() in B")

    def k(self):
        print(self.i)
        print("method k() in B")
        
# B().m() # 会输出 "method in B"
b = B()
A.m(b)