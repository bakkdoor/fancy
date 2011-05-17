# example of composing futures:

def do_large_computation: x {
  x upto: (x ** x)
}

# FutureSend#&& takes a Block (or a Callable - something that implements 'call:)
# and creates a new FutureSend that executes the given Block with the value of the first FutureSend
# when it has finished its computation. This makes pipelining tasks easy.

f = self @ do_large_computation: 5 && @{select: 'even?} && @{inspect println}
"computing .. " println
f value

#the above is the same as:
# f = self @ do_large_computation: 5
# f = f when_done: @{select: 'even?}
# f = f when_done: @{inspect println}
# "computing .. " println
# f value
