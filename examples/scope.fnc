def class ScopeTest {
  def test {
    "in ScopeTest#test" println;
    __current_scope__ parent define: "foo" value: "bar"
  }
};

t = ScopeTest new;
foo inspect println; # => nil
t test;
foo inspect println; # => "bar"
__current_scope__ get: "foo" . inspect println # => "bar" (same as line above)
