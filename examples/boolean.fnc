# some boolean expressions & logicial operations

true and: true . println; # true
true and: false . println; # nil
false and: false . println; # nil
true and: nil . println; # nil
nil and: nil . println; # nil
false and: nil . println; # nil

"--------------" println;

# won't print string
nil if_true: {
  "this should _not_ be displayed" println
};

# will print string
nil if_false: {
  "this _should_ be displayed" println
}

