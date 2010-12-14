regex = /[a-z]+[A-Z]*foo/
str = "heLLofoo"

if: (str =~ regex) then: |idx| {
  "match at index: " ++ idx ++ " with character: " print
  str[idx] inspect println
}
