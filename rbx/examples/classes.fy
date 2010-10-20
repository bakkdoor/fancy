class Person {
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

class PersonWithAge : Person {
  def initialize: name age: age {
    @name = name
    @age = age
  }

  def to_s {
    super to_s ++ " and age: " ++ @age
  }
}

p2 = PersonWithAge new: "Christopher" age: 23
p2 println
