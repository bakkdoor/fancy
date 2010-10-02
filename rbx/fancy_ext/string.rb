class String
  define_method("++") do |other|
    self + other.to_s
  end
end
