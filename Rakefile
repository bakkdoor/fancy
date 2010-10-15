
# This will eventually replace our current Makefile, once we can
# remove all the old c++ code.

load File.dirname(__FILE__) + "/rbx/parser/Rakefile"

task :clean do
  rm_f Dir.glob(File.dirname(__FILE__)+"/**/*.{rbc,fyc}")
  sh 'make', 'clean'
end

src_files = Dir.glob(File.dirname(__FILE__)+"/src/*").map { |f| file f }

fancy_bin = file File.dirname(__FILE__)+"/bin/fancy" => src_files do
  task(:compile).invoke
end

fy_files = Dir.glob(File.dirname(__FILE__)+"/lib/**/*.fy").map { |fy| file fy }
fyc_files = fy_files.map do |task|
  file "#{task.to_s}c" => [task, fancy_bin] do
    sh fancy_bin.to_s, '-c', task.to_s
  end
end

task :bootstrap => fyc_files

task :compile do
  sh 'make'
end

task :test_native do
  sh 'make', 'test'
end

task :test => [:test_native, "parser:test"]

task :default => :bootstrap


