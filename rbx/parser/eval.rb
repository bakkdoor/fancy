require File.expand_path("../compiler.rb", File.dirname(__FILE__))
require File.expand_path("parser.rb", File.dirname(__FILE__))


module Fancy
  def self.eval(code)
    compiled_method = Rubinius::Compiler.compile_fancy_code(code)
  end
end

if $0 == __FILE__
  if ARGV.length.zero?
    Fancy.eval(STDIN.read)
  else
    if File.exist?(ARGV.first)
      Fancy.eval(File.read(ARGV.first))
    else
      Fancy.eval(ARGV.first)
    end
  end
end
