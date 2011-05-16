# factorial.fy
# Example of factorial

class Fixnum {
  def factorial {
    1 upto: self . product
  }
}

1 upto: 10 do: |i| {
  "#{i}! = #{i factorial}" println
}
