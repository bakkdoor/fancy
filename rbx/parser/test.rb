require File.dirname(__FILE__) + "/../eval"
require File.dirname(__FILE__) + "/../loader"

if __FILE__ == $0
  raise "Expected file name to evaluate" if ARGV.empty?
  Fancy.eval File.read(ARGV.first)
else
  Fancy.eval "'Hello_Bootstrap println"
end
