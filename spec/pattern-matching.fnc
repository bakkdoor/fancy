# -*- coding: utf-8 -*-
# pattern matching example

package: PatternMatchingTest;
import: [System];

arr = [:foo, :bar, :baz];

arr match {
  [] -> {
    Console println: "Got empty array!"
  }
  [x] -> {
    Console println: "Got array with only one element!"
    Console println: "Element is: #{x inspect}"
  }
  # in this case, this pattern will match with:
  # x = :foo and rest = [:bar, :baz]
  [x, rest] -> {
    Console println: "Got array with multiple elements!";
    Console println: "Head of array is: #{x inspect}"
  }
};

hash = <[:foo => :bar, :bar => :baz]>;

hash match {
  <[]> -> {
    Console println: "Got empty hash!"
  }
  <[key => val]> -> {
    Console println: "Got hash with one pair: #{key inspect} => #{val inspect}"
  }
  <[key => val, rest_pairs]> -> {
    Console println: "Got hash with multiple pairs";
    Console println: "First pair: #{key inspect} => #{val inspect}"

    rest_pairs each: |k,v| {
      Console println: "Next pair: #{key inspect} => #{val inspect}"
    }
  }
};


numbers = 1 upto: 10; # => [1,2,3,4,5,6,7,8,9,10]

numbers each: |x| {
  x match {
    (1..5) -> {
      Console println: "Got number between 1 and 5: #{x}"
    }
    (6..10) -> {
      Console println: "Got number between 6 and 10: #{x}"
    }
  }
};

### class-based pattern-matching

def class Person {
  read_write_slots: [:name, :age, :city];
  def initialize: name age: age city: city {
    @name = name;
    @age = age;
    @city = city
  }
};

persons = [];
persons << $ Person new: "Christopher" age: 23 city: "Osnabrück";
persons << $ Person new: "Foobar" age: 30 city: "New York";
persons << $ Person new: "Barbaz" age: 25 city: "Los Angeles";

persons collect: |p| {
  p match {
    # extract name & age
    Person%[:name => name, :age => (20..25)]% -> { [name, age] }
    # any non-matching person will cause the match to return nil
  }
  # remove nil values then iterate over the remaining
} compact each: |name_with_age| {
  # the ';' (comma) is the same as in smalltalk: method call cascade
  # so the following line is equivalent to:
  ## name, age = name_with_age first, name_with_age second
  name, age = name_with_age first; second;
  # only the first (Christopher) and third (Barbaz) persons' name &
  # age will be output here, since they match the age
  Console println: "Found appropriate person: #{name} (#{age})"
}
