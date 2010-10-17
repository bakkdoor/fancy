require File.dirname(__FILE__) + "/../eval"

if __FILE__ == $0
  raise "Expected file name to evaluate" if ARGV.empty?
  Fancy.eval File.read(ARGV.first)
end
