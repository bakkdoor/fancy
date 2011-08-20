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

load_rb   = _("boot/load.rb")

namespace :compiler do

  task :clean do
    rm_rf _("boot/rbx-compiler/parser/conftest.dSYM")
    rm_rf _("boot/compiler"), :verbose => false
  end

  desc "Compile fancy using the stable compiler (from boot/compiler)."
  task :compile do
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

  desc "Compile fancy using boot/rbx-compiler into boot/compiler/"
  task :rootstrap do
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

    say "Using fresh built compiler as `stable compiler' in boot/compiler"
  end

  task :compile_tests do
    say "Compiling test files"
    system("bin/fancy -c tests/*.fy > /dev/null")
  end

  task :bootstrap do
    ["compiler:rootstrap", "compiler:compile", "compiler:wootstrap"].each do |t|
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
task :clean => ["compiler:clean", :clean_compiled]


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
compiled = sources.map { |s| file((s.to_s+"c") => [s]) { compile s } }

task :bootstrap_if_needed do
  task(:bootstrap).invoke unless File.directory? _("boot/compiler")
end

task :compile => compiled

desc "Runs the test suite."
task :test do
  sh! _('bin/fspec')
end

task :tests do
  task(:test).invoke
end

task "tests/" do
  task(:test).invoke
end

task :bootstrap => ["compiler:bootstrap"]

task :default => [:bootstrap_if_needed, :compile]

desc "Runs all example files in examples/ dir"
task :examples do
  Dir.glob(_("examples/*.fy")).each do |f|
    puts "Running #{f}"
    puts
    sh! _('bin/fancy'), f
    puts
  end
end

task "examples/" do
  task(:examples).invoke
end
