class ZeroDivError : Error

def divide: x by: y {
  with_restarts: {
    return_default: { 1 }
  } do: {
    if: (y == 0) then: {
      ZeroDivError new signal!
    } else: {
      x / y
    }
  }
}

with_handlers: @{
  when: ZeroDivError do: {
    restart: 'return_default
  }
} do: {
  divide: 10 by: 2 . println # prints 5
  divide: 10 by: 0 . println # prints 1 (return_default restart returns 1)
}
