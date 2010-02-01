# -*- coding: utf-8 -*-
# the fancy language spec
# (C) 2010 Christopher Bertels <chris@fany-lang.org>

class Person {
  # creates getters & setters for slots
  read_write_slots: [:name, :age, :city]

  # => could also be written as follows:
  # def Person new: name age: age city: city { ... }
  class_scope: {
    def new: name age: age city: city {
      @name = name
      @age = age
      @city = city
    }
  }

  def go_to: city {
    city is_a?: City if_true: {
      @city = city
    }
  }
}

# usage example:
osna = City new: "Osnabrück"
p = Person new: "Christopher" age: 22 city: osna
berlin = City new: "Berlin"
p go_to: berlin # => p city will then be set to berlin


## shape example

class Shape {
  read_slots: [:name]
    
  def Shape new: name {
    @name = name
  }

  def area {
    Error new: "Area method not implemented"
  }
}

class Rectangle < Shape {
  read_slots: [:height, :width]

  def Rectangle new: dimension_arr {
    dimension_arr size ==: 2 if_true: {
      # multiple assignment with first & second values of
      # dimension_arr
      @width, @height = dimension_arr first, dimension_arr second
    }
  }

  def area {
    @width *: @height
  }
}

class Circle < Shape {
  read_slots: [:radius]

  def Circle new: radius {
    radius >=: 0 if_true: {
      @radius = radius
    } else: {
      @radius = 0
    }
  }

  def area {
    Math::PI *: (@radius squared)
  }
}

# usage example:

def main: args {
  width = Console readln: "Please enter a width: " to_num
  height = Console readln: "Please enter a height: " to_num
  rect = Rectangle new: [width, height]

  radius = Console readln: "Please enter a radius: " to_num
  circ = Circle new: radius

  # => string interpolation as in ruby :)
  Console println: "Rectangle area: #{rect area}"
  Console println: "Circle area: #{circle area}"

  shape = Shape new: "won't work!"
  # shape doesn't have area method correctly defined
  # => notice, how try:catch: is just a regular method
  # (at least it's used like one) that takes two blocks, the second
  # block taking an argument (being the exception that gets thrown <-
  # it's optional though)
  try: {
    shape
  } catch: |err| {
    Console println: (err message)
  }

  i = 0
  { i <: 10 } while_true: {
    i = Console readln: "Enter any number: " to_num
  }

  # block with one param:
  10 times: |x| {
    Console println: x
  }

  # block with two params:
  10 upto: 100 each_with_index: |x i| {
    Console println: "Num: #{x}, Index: #{i}"
  }
}
