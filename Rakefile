# This will eventually replace our current Makefile, once we can
# remove all the old c++ code.

load File.dirname(__FILE__) + "/rbx/parser/Rakefile"
load File.dirname(__FILE__) + "/boot/parser/Rakefile"

_ = lambda { |f| File.expand_path(f, File.dirname(__FILE__)) }

desc "Deletes all .rbc and .fyc files."
task :clean do
  rm_f Dir.glob(_["**/*.{rbc,fyc}"])
end

src_files = Dir.glob(_["src/*"]).map { |f| file f }

fancy_bin = file _["bin/fancy"] => src_files do
  task(:compile).invoke
end

desc "Compiles the fancy std lib."
task :bootstrap => [fancy_bin] do
  sh 'rbx', _["rbx/compiler.rb"], "--batch", *Dir.glob(_["lib/**/*.fy"])
end

task :boot => [fancy_bin, "parser_ext:default"] do
  sh 'rbx', _["rbx/compiler.rb"], "--batch", *Dir.glob(_["boot/**/*.fy"])
end

desc "Runs the test suite."
task :test do
  sh _['bin/fancy -e "ARGV rest rest each: |f| { require: f }" tests/*.fy']
end

desc "Invokes bootstrap."
task :default => :bootstrap


