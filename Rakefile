
# This will eventually replace our current Makefile, once we can
# remove all the old c++ code.

load File.dirname(__FILE__) + "/rbx/parser/Rakefile"

task :clean do
  rm_f Dir.glob(File.dirname(__FILE__)+"/**/*.{rbc,fyc}")
end

task :build do
  sh 'make'
  sh 'make', 'bootstrap'
end

task :default => :build


