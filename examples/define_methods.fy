arr = [1,2,3]
arr define_singleton_method: "foo" with: {
  "in foo!" println
  self inspect println
}

arr receive_message: 'foo

arr undefine_singleton_method: "foo"

try {
  arr receive_message: 'foo
} catch NoMethodError => e {
  e println
}
