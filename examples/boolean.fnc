# some boolean expressions & logicial operations

def class Object {
  def print {
    Console println: self
  }
};

true and: true . print;
true and: false . print;
false and: false . print;
true and: nil . print;
nil and: nil . print;
false and: nil . print;

"--------------" print;

nil if_true: {
  "this should _not_ be displayed" print
};

nil if_false: {
  "this _should_ be displayed" print
}

