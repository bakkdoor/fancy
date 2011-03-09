S = Struct new: ['foo, 'bar, 'baz]
s = S new: (1,2,3)
s println

s foo: 10
s bar: 20
s baz: 30

s println