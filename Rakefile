# This will eventually replace our current Makefile, once we can
# remove all the old c++ code.

load File.dirname(__FILE__) + "/boot/parser/Rakefile"

def _(f)
  File.expand_path(f, File.dirname(__FILE__))
end

desc "Deletes all .rbc and .fyc files."
task :clean do
  rm_f Dir.glob(_ "**/*.{rbc,fyc}")
  rm_f _(".compiled")
end

desc "Compile the parser extension"
task :parser => "parser_ext:compile"

def compile_fancy(compiler_dir, output_dir)
  _("#{compiler_dir}/parser").tap do |parser_dir|
    mkdir_p parser_dir, :verbose => false
    cp Dir.glob(_ "boot/parser/fancy_parser_ext.*"), parser_dir
  end
  lib_fy = Dir.glob(_ "lib/**/*.fy").sort
  lib_fy.unshift "--batch" if RakeFileUtils.verbose_flag
  sh 'rbx', _("boot/load.rb"), _("#{compiler_dir}/boot.fyc"), _("#{compiler_dir}/compile.fyc"), '--source-path', _("lib"), '--output-path', _(output_dir), *lib_fy
  boot_fy = Dir.glob(_ "boot/**/*.fy").sort
  boot_fy.unshift "--batch" if RakeFileUtils.verbose_flag
  sh 'rbx', _("boot/load.rb"), _("#{compiler_dir}/boot.fyc"), _("#{compiler_dir}/compile.fyc"), '--source-path', _("boot"), '--output-path', _(output_dir), *boot_fy
end

desc "Compile fancy into boot/.compiled dir. (Compiles using current compiler from .compiled)"
task :bootstrap => :parser do
  compile_fancy ".compiled", "boot/.compiled"
end

desc "Compile fancy into .compiled dir. (Compiles using staged compiler from boot/.compiled)"
task :compile => :parser do
  compile_fancy "boot/.compiled", ".compiled"
end

task :default => :compile

