# -*- coding: utf-8 -*-
# (C) 2010 Christopher Bertels <chris@fancy-lang.org>

def class City {
  self read_slots: [:city];
  def initialize: name {
    @name = name
  };

  def to_s {
    "City: " ++ @name
  }
};

def class Person {
  # creates getters & setters for slots
  self read_write_slots: [:name, :age, :city];

  # Person constructor
  def initialize: name {
    @name = name
  };

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
  };

  def to_s {
    "Person: " ++ @name ++ ", " ++ @age ++ " years old, living in " ++ @city
  }
};

# usage example:
osna = City new: "Osnabrück";
p = Person new: "Christopher";
p age: 23;
p city: osna;

p println;

berlin = City new: "Berlin";
p go_to: berlin; # => p city will then be set to berlin

p println
