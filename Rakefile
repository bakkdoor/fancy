require 'rbconfig'

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
      sh 'flex', '--outfile', lexer_c, '--header-file=lexer.h', lexer_lex
    end
  end

  file parser_c => file(parser_y) do
    Dir.chdir(ext_dir) { sh 'bison', '--output', parser_c, '-d', '-v', parser_y }
  end

  file makefile => file(extconf) do
    Dir.chdir(ext_dir) { sh 'rbx', extconf }
  end

  desc "Generate parser source from flex/bison"
  task :generate => [parser_c, lexer_c, makefile]

  file parser_e => file(makefile) do
    sh 'make', '-C', ext_dir
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
    rm_f Dir.glob(_("*.{o,so,rbc,log,output}", ext_dir)), :verbose => false
  end

end


namespace :compiler do

  boot_parser_e = _("boot/compiler/parser/ext/"+File.basename(parser_e))

  file boot_parser_e => file(parser_e) do
    mkdir_p File.dirname(boot_parser_e)
    cp parser_e, boot_parser_e
  end

  task :clean do
    rm_f boot_parser_e, :verbose => false
    rm_rf _("boot/compiler"), :verbose => false
  end

  desc "Compile fancy using the stable compiler (from boot/compiler)."
  task :compile => file(boot_parser_e) do
    cmd = ['rbx', load_rb]
    cmd << _("boot/compiler/boot.fyc")
    cmd << _("boot/compiler/compiler.fyc")
    cmd << _("boot/compiler/compiler/command.fyc")
    cmd << _("boot/compiler/compile.fyc")
    cmd << "--"
    cmd << "--batch" if RakeFileUtils.verbose_flag == true

    # this is slow and absurd but it seems to work o___O
    sources = Dir.glob(_("lib/**/*.fy"))
    sources.each do |file|
      sh *(cmd + [file])
    end
  end

  load("boot/rbx-compiler/parser/Rakefile")

  desc "Compile fancy using boot/rbx-compiler into boot/compiler/"
  task :rootstrap => "compiler:rbx_parser:ext" do

    output = _("boot/compiler")

    cmd = ['rbx']
    cmd << _("boot/rbx-compiler/compiler.rb")
    cmd << "--batch" if RakeFileUtils.verbose_flag == true
    cmd << "--output-path" << output

    src_path = ["--source-path", _("lib")]
    sources = Dir.glob(_("lib/**/*.fy"))
    sh *(cmd + src_path + sources)

    src_path = ["--source-path", _("boot")]
    sources = Dir.glob(_("boot/*.fy"))
    sh *(cmd + src_path + sources)

  end

  desc "Compile fancy using lib/ compiler into boot/compiler/"
  task :wootstrap do
    output = _("boot/.wootstrap")

    cmd = ['rbx', load_rb]
    cmd << _("lib/boot.fyc")
    cmd << _("lib/compiler.fyc")
    cmd << _("lib/compiler/command.fyc")
    cmd << _("boot/compiler/compile.fyc")
    cmd << "--"
    cmd << "--batch" if RakeFileUtils.verbose_flag == true
    cmd << "--output-path" << output

    source_dirs  = ["lib", "lib/parser", "lib/compiler", "lib/compiler/ast",
                    "lib/rbx", "lib/package", "boot"]

    source_dirs.each do |dir|
      sources = Dir.glob(_(dir + "/*.fy"))
      src_path = ["--source-path", _(dir.split("/").first)]
      # same as above. #slowashell
      sources.each do |file|
        sh *(cmd + src_path + [file])
      end
    end

    mkdir_p _("parser/ext", output)
    cp parser_e, _("parser/ext", output)

    rm_rf _("boot/compiler")
    mv _("boot/.wootstrap"), _("boot/compiler")
  end

  task :bootstrap => ["rbx_parser:ext", file(boot_parser_e)] do
    ["compiler:rootstrap", "compiler:compile", "compiler:wootstrap"].each do |t|
      task(t).reenable
      task(t).execute
    end
  end

end

desc "Deletes all .rbc and .fyc files."
task :clean_compiled do
  compiled = Dir.glob(_ "**/*.{rbc,fyc}")
  rm_f compiled, :verbose => false
end

desc "Clean compiled files."
task :clean => ["parser:clean", "compiler:clean", :clean_compiled]

task :compile do

  task(:bootstrap).invoke if file(parser_e).needed?

  cmd = ['rbx', load_rb]
  cmd << _("lib/boot.fyc")
  cmd << _("lib/compiler.fyc")
  cmd << _("lib/compiler/command.fyc")
  cmd << _("boot/compile.fyc")
  cmd << "--"
  cmd << "--batch" if RakeFileUtils.verbose_flag == true

  source_dirs  = ["lib", "lib/parser", "lib/compiler", "lib/compiler/ast",
                  "lib/rbx", "lib/package", "boot"]

  source_dirs.each do |dir|
    sources = Dir.glob(_("*.fy", dir))
    sh *(cmd + sources)
  end
end

desc "Runs the test suite."
task :test do
  sh _('bin/fancy'),
  '-e', 'ARGV rest rest each: |f| { require: f }',
  *Dir.glob(_("tests/*.fy"))
end

task :bootstrap => ["compiler:bootstrap"]

task :default => :compile
