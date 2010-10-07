def class Person {
  @@a_classvar = "foo"
  def initialize: name {
    @name = name
  }

  def to_s {
    "Person with name: " ++ @name
  }

  def Person class_var {
    @@a_classvar
  }
}

p = Person new: "Christopher"
p println
Person class_var println
