# person.fy
# Annotated example of fancy's classes mechanism

class City {
  read_slot: 'name
  def initialize: @name {
  }

  def to_s {
    "City: " ++ @name
  }
}

class Person {
  # creates getters & setters for slots
  read_write_slots: ['name, 'age, 'city]

  # Person constructor method for creating a new person with a name,
  # age and city.
  # A method that starts with initialize: will cause a class factory
  # method being generated, that calls this method when being called.
  # The name of the class factory method is the same as the instance
  # method but having initialize: replaced by new:.
  # So in this case: Person##new:age:city:
  # which calls this instance method internally
  def initialize: @name age: @age city: @city

  def go_to: city {
    # The .-operator (dot) manages left associativity and treats
    # everything left of it as one expression and everything right of
    # it as a method_call to the left. In this case the following line
    # of code is equivalent to:
    ## (city is_a?: City) if_true: { ... }

    # While using parentheses would definately work, the dot-operator
    # makes left-grouping of expressions much easier.
    # In contrast to e.g. Smalltalk, Fancy isn't compiled but
    # interpreted so there usually is not some predefined knowledge of
    # which methods exist etc., which makes it impossible to determine
    # if we're dealing with a two-argument method call or a chained
    # method call ('is_a?:if_true:' vs. '(is_a?: ..) if_true: ..')
    city is_a?: City . if_true: {
      @city = city
    }
  }

  def to_s {
    "Person: #{@name}, #{@age} years old, living in #{@city}"
  }
}

# usage example:
osna = City new: "Osnabrück"
p = Person new: "Christopher" age: 23 city: osna
p println

berlin = City new: "Berlin"
p go_to: berlin # => p city will then be set to berlin

p println
