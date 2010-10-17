arr = [1,2,3]
arr define_singleton_method: "foo" with: {
  "in foo!" println
  self inspect println
}

arr send: 'foo

arr undefine_singleton_method: "foo"

try {
  arr send: 'foo
} catch NoMethodError => e {
  e println
}
