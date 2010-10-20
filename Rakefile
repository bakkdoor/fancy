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

task :test do
  Dir.glob("tests/*.fy").each do |t|
    sh _['bin/fancy'], _[t]
  end
end


task :default => :bootstrap


