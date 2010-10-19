# This will eventually replace our current Makefile, once we can
# remove all the old c++ code.

load File.dirname(__FILE__) + "/rbx/parser/Rakefile"

_ = lambda { |f| File.expand_path(f, File.dirname(__FILE__)) }

task :clean do
  rm_f Dir.glob(_["**/*.{rbc,fyc}"])
end

src_files = Dir.glob(_["src/*"]).map { |f| file f }

fancy_bin = file _["bin/fancy"] => src_files do
  task(:compile).invoke
end

fy_files = Dir.glob(_["lib/**/*.fy"]).map { |fy| file fy }
fyc_files = fy_files.map do |task|
  file "#{task.to_s}c" => [task, fancy_bin] do
    sh 'rbx', _["rbx/compiler.rb"], task.to_s
  end
end

task :bootstrap => fyc_files

desc "Copy compiled .fyc files from lib/ to rbx/boot so we can bootstrap using them."
task :bootsave do
  rm_f _["rbx/boot"], :verbose => false
  cp_r _["lib"], _["rbx/boot"], :verbose => false
  rm Dir.glob(_["rbx/boot/**/*.fy"]), :verbose => false
end


task :test_native do
  sh 'make', 'test'
end

task :test => [:test_native, "parser:test"]

task :default => :bootstrap


