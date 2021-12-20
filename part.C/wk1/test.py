from toy import A

i = 456

class B(A):

    def __init__(self) -> None:
        super().__init__()
        self.i = 2


def m():
    print(i)

i = 123

def n():
    print(i)