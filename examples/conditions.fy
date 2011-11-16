def divide: x by: y {
  with_restarts: {
    use_value: |x| { x }
    use_default: { 10 }
  } do: {
    x / y
  }
}

with_handlers: @{
  when: ZeroDivisionError do: {
    restart: 'use_value with: $ 100 random
  }
} do: {
  divide: 10 by: 2 . println # prints 5
  divide: 10 by: 0 . println # prints random value between 0 and 100 (see condition handler above)
}