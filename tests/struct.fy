FancySpec describe: Struct with: {
  Point = Struct new: ('x, 'y)

  it: "creates a struct class" when: {
    Point is_a?: Class . is: true
  }

  it: "creates setter methods for a struct's fields" when: {
    Point instance_methods includes?: "x:" . is: true
    Point instance_methods includes?: "y:" . is: true
  }

  it: "creates getter methods for a struct's fields" when: {
    Point instance_methods includes?: ":x" . is: true
    Point instance_methods includes?: ":y" . is: true
  }

  it: "works with getter and setter methods as expected" when: {
    p = Point new: (2, 3)
    p x is: 2
    p y is: 3
    p x: 10
    p y: 20
    p x is: 10
    p y is: 20
  }
}
