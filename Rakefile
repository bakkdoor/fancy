require 'rbconfig'

def say(*msg)
  puts(*msg) unless RakeFileUtils.verbose_flag == false
end

def sh!(*args, &block)
  old_verbose = RakeFileUtils.verbose_flag
  begin
    RakeFileUtils.verbose_flag = nil if RakeFileUtils.verbose_flag == :default
    sh(*args, &block)
  ensure
    RakeFileUtils.verbose_flag = old_verbose
  end
end

def _(f, base = File.dirname(__FILE__))
  File.expand_path(f, base)
end


dl_ext    = RbConfig::CONFIG['DLEXT']
ext_dir   = _("lib/parser/ext")
parser_e  = _("fancy_parser.#{dl_ext}", ext_dir)
load_rb   = _("boot/load.rb")

namespace :parser do

  lexer_lex = _("lexer.lex", ext_dir)
  lexer_c   = _("lexer.c", ext_dir)
  parser_y  = _("parser.y", ext_dir)
  parser_c  = _("parser.c", ext_dir)
  extconf   = _("extconf.rb", ext_dir)
  makefile  = _("Makefile", ext_dir)

  file lexer_c => file(lexer_lex) do
    Dir.chdir(ext_dir) do
      sh! 'flex', '--outfile', lexer_c, '--header-file=lexer.h', lexer_lex
    end
  end

  file parser_c => file(parser_y) do
    Dir.chdir(ext_dir) { sh! 'bison', '--output', parser_c, '-d', '-v', parser_y }
  end

  file makefile => file(extconf) do
    Dir.chdir(ext_dir) { sh! 'rbx', extconf }
  end

  desc "Generate parser source from flex/bison"
  task :generate => [parser_c, lexer_c, makefile]

  file parser_e => file(makefile) do
    sh! 'make', '-C', ext_dir
  end

  desc "Compile the parser extension"
  task :compile => file(parser_e)

  desc "Removed generated parser sources"
  task :remove do
    rm_f [_("parser.h", ext_dir), _("lexer.h", ext_dir)], :verbose => false
    rm_f [makefile, parser_c, lexer_c], :verbose => false
  end

  desc "Clean compiled files."
  task :clean do
    rm_f Dir.glob(_("*.{o,so,rbc,log,output,bundle}", ext_dir)), :verbose => false
    rm_rf [_("conftest.dSYM", ext_dir)], :verbose => true
  end

end


namespace :compiler do

  boot_parser_e = _("boot/compiler/parser/ext/"+File.basename(parser_e))

  file boot_parser_e => file(parser_e) do
    mkdir_p File.dirname(boot_parser_e), :verbose => false
    cp parser_e, boot_parser_e, :verbose => false
  end

  task :clean do
    rm_f boot_parser_e, :verbose => false
    rm_rf _("boot/rbx-compiler/parser/conftest.dSYM")
    rm_rf _("boot/compiler"), :verbose => false
  end

  desc "Compile fancy using the stable compiler (from boot/compiler)."
  task :compile => file(boot_parser_e) do
    say "Compiling fancy using stable compiler."

    cmd = ['rbx -Xint', load_rb]
    cmd << _("boot/compiler/boot.fyc")
    cmd << _("boot/compiler/compiler.fyc")
    cmd << _("boot/compiler/compiler/command.fyc")
    cmd << _("boot/compiler/compile.fyc")
    cmd << "--"
    cmd << "--batch" if RakeFileUtils.verbose_flag == true

    sources = Dir.glob("lib/**/*.fy")
    system (cmd + sources).join(" ")
  end

  load("boot/rbx-compiler/parser/Rakefile")

  desc "Compile fancy using boot/rbx-compiler into boot/compiler/"
  task :rootstrap => "compiler:rbx_parser:ext" do
    say "Compiling fancy into boot/compiler using ruby-based compiler from boot/rbx-compiler."

    output = _("boot/compiler")

    cmd = ['rbx -Xint']
    cmd << _("boot/rbx-compiler/compiler.rb")
    cmd << "--batch" if RakeFileUtils.verbose_flag == true
    cmd << "--output-path" << output

    src_path = ["--source-path", _("lib")]
    sources = Dir.glob(_("lib/**/*.fy"))
    system (cmd + src_path + sources).join(" ")

    src_path = ["--source-path", _("boot")]
    sources = Dir.glob(_("boot/*.fy"))
    system (cmd + src_path + sources).join(" ")

    sh! "rbx", _("boot/rbx-compiler/compiler.rb"), _("boot/compile.fy")

  end

  desc "Compile fancy using lib/ compiler into boot/compiler/"
  task :wootstrap do

    say "Compiling fancy into boot/compiler using development compiler from lib/"

    output = _("boot/.wootstrap")

    cmd = ['rbx -Xint', load_rb]
    cmd << _("lib/boot.fyc")
    cmd << _("lib/compiler.fyc")
    cmd << _("lib/compiler/command.fyc")
    cmd << _("boot/compiler/compile.fyc")
    cmd << "--"
    cmd << "--batch" if RakeFileUtils.verbose_flag == true
    cmd << "--output-path" << output

    sources = Dir.glob("lib/**/*.fy")
    system (cmd + sources).join(" ")

    mkdir_p _("parser/ext", output), :verbose => false
    cp parser_e, _("parser/ext", output), :verbose => false

    say "Using fresh built compiler as `stable compiler' in boot/compiler"

    rm_rf _("boot/compiler")
    mv _("boot/.wootstrap"), _("boot/compiler")
  end

  task :compile_tests do
    say "Compiling test files"
    system("bin/fancy -c tests/*.fy > /dev/null")
  end

  task :bootstrap => ["parser:generate", "rbx_parser:ext", file(boot_parser_e)] do
    ["compiler:rootstrap", "compiler:compile", "compiler:wootstrap", "compiler:compile_tests"].each do |t|
      task(t).reenable
      task(t).execute
    end
  end

  task :diff do
    require 'open3'
    sources = Dir.glob(_("lib/**/*.fy"))

    say "Compiling fancy using stable compiler."
    cmd = ['rbx', load_rb]
    cmd << _("lib/boot.fyc")
    cmd << _("lib/compiler.fyc")
    cmd << _("lib/compiler/command.fyc")
    cmd << _("boot/compiler/compiler.fyc")
    cmd << "--"

    sources.each do |file|
      f = file.gsub(_("lib"), _("diff/fy-compiler")).gsub(/.fy$/, ".asm")
      puts f
      mkdir_p File.dirname(f), :verbose => false
      Open3.popen3 *(cmd + [file, "-B"]) do |stdin, stdout, stderr|
        File.open(f, "w") { |bc| bc.print stdout.read }
      end
    end


    cmd = ['rbx']
    cmd << _("boot/rbx-compiler/compiler.rb")

    sources.each do |file|
      f = file.gsub(_("lib"), _("diff/rb-compiler")).gsub(/.fy$/, ".asm")
      puts f
      mkdir_p File.dirname(f), :verbose => false
      Open3.popen3 *(cmd + [file, "-B"]) do |stdin, stdout, stderr|
        File.open(f, "w") { |bc| bc.print stdout.read }
      end
    end

    sources.each do |file|
      a = file.gsub(_("lib"), _("diff/rb-compiler")).gsub(/.fy$/, ".asm")
      b = file.gsub(_("lib"), _("diff/fy-compiler")).gsub(/.fy$/, ".asm")
      f = file.gsub(_("lib"), _("diff/diffs")).gsub(/.fy$/, ".diff")
      mkdir_p File.dirname(f), :verbose => false
      puts f
      Open3.popen3 'diff', '-u9999', a, b do |stdin, stdout|
        File.open(f, "w") { |bc| bc.print stdout.read }
      end
    end

  end

end

desc "Deletes all .rbc and .fyc files."
task :clean_compiled do
  compiled = Dir.glob(_ "**/*.{rbc,fyc}")
  rm_f compiled, :verbose => false
end

desc "Clean compiled files."
task :clean => ["parser:clean", "parser:remove", "compiler:clean", :clean_compiled]


def compile(source)
  cmd = ['rbx', _("boot/load.rb")]
  cmd << _("lib/boot.fyc")
  cmd << _("lib/compiler.fyc")
  cmd << _("lib/compiler/command.fyc")
  cmd << _("boot/compile.fyc")
  cmd << "--"
  cmd << "--batch" if RakeFileUtils.verbose_flag == true
  cmd << source.to_s
  sh! *cmd
end

sources = Dir.glob(_("{lib,boot}/**/*.fy")).map { |f| file f }
compiled = sources.map { |s| file((s.to_s+"c") => [s, file(parser_e)]) { compile s } }

task :bootstrap_if_needed do
  task(:bootstrap).invoke unless File.directory? _("boot/compiler")
end

task :compile => compiled

desc "Runs the test suite."
task :test do
  sh! _('bin/fancy'),
  '-e', 'ARGV rest rest each: |f| { require: f }',
  *Dir.glob(_("tests/*.fy"))
end

task :tests do
  task(:test).invoke
end

task "tests/" do
  task(:test).invoke
end

task :bootstrap => ["compiler:bootstrap"]

task :default => [:bootstrap_if_needed, :compile]
