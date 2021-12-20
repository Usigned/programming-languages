# edit at 2021-12-19
# review of stream
# stream implementation in Python
def stream_maker(fn, arg):
    def f(x):
        return (x, lambda : f(fn(x, arg)))
    return lambda : f(arg)


class Stream:
    def __init__(self, fn, arg, x_thunk=None) -> None:
        self.fn = fn
        self.arg = arg
        self.x_thunk = x_thunk if x_thunk else lambda: arg

    def next(self):
        x = self.x_thunk()
        return (x, Stream(fn=self.fn, arg=self.arg, x_thunk=lambda:self.fn(x, self.arg)))