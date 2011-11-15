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
  when: ZeroDivError do: |c| {
    restart: 'return_default
  }
} do: {
  divide: 10 by: 2 . println
  divide: 10 by: 0 . println
}