class Rubinius::CompiledMethod
  define_method("documentation:") { |s| instance_variable_set(:@documentation, s) }
end
