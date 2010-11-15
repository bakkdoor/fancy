regex = /[a-z]+[A-Z]*foo/
str = "heLLofoo"

str =~(regex) if_do: |idx| {
  "match at index: " ++ idx ++ " with character: " print
  str[idx] inspect println
}
