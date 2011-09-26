# needed during bootstrapping
class Object
  define_method(":*stdout*") do
    STDOUT
  end
end
