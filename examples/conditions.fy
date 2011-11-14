class ZeroDivError : Error

def divide: x by: y {
  restarts: {
    return_default: { 1 }
  } in: {
    if: (y == 0) then: {
      ZeroDivError new signal!
    } else: {
      x / y
    }
  }
}

handlers: @{
  when: ZeroDivError do: |c| {
    invoke_restart: 'return_default
  }
} in: {
  divide: 10 by: 2 . println
  divide: 10 by: 0 . println
}