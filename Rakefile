# This will eventually replace our current Makefile, once we can
# remove all the old c++ code.

load File.dirname(__FILE__) + "/boot/parser/Rakefile"

_ = lambda { |f| File.expand_path(f, File.dirname(__FILE__)) }

desc "Deletes all .rbc and .fyc files."
task :clean do
  rm_f Dir.glob(_["**/*.{rbc,fyc}"])
  rm_f _[".compiled"]
end

desc "Compile the parser extension"
task :parser => "parser_ext:default"

desc "Bootstrap fancy into boot/.compiled/ directory"
task :bootstrap => [:parser] do
  cp Dir.glob(_["boot/parser/fancy_parser_ext.*"]), _["boot/.compiled/parser/"]
  sh 'rbx', _["boot/load.rb"], _["boot/.compiled/compile.fyc"], "--batch", "--source-path", _["lib"], "--output-path", _["boot/.compiled"], *Dir.glob(_["lib/**/*.fy"])
  sh 'rbx', _["boot/load.rb"], _["boot/.compiled/compile.fyc"], "--batch", "--source-path", _["boot"], "--output-path", _["boot/.compiled"], *Dir.glob(_["boot/**/*.fy"])
end

desc "Compile fancy"
task :compile => [:parser] do
  mkdir_p _[".compiled/parser"]
  cp Dir.glob(_["boot/parser/fancy_parser_ext.*"]), _[".compiled/parser/"]
  sh 'rbx', _["boot/load.rb"], _["boot/.compiled/compile.fyc"], "--batch", "--source-path", _["lib"], "--output-path", _[".compiled"], *Dir.glob(_["lib/**/*.fy"])
  sh 'rbx', _["boot/load.rb"], _["boot/.compiled/compile.fyc"], "--batch", "--source-path", _["boot"], "--output-path", _[".compiled"], *Dir.glob(_["boot/**/*.fy"])
end

task :default => :compile

