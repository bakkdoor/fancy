@path = []
def fancy_require(file)
  @path.push(File.expand_path(File.dirname(file), @path.last))

  file = File.expand_path(File.basename(file), @path.last)

  file = file + "c" if file =~ /.fy$/
  file = file+".fyc" unless file =~ /\.fyc$/
  raise "File not found #{file}" unless File.exist?(file)

  cl = Rubinius::CodeLoader.new(file)
  cm = cl.load_compiled_file(file, 0)

  source = file.sub(/\.fyc/, ".fy")

  script = cm.create_script(false)
  script.file_path = source

  MAIN.__send__ :__script__

  @path.pop
end

require File.expand_path("../rbx/fancy_ext", File.dirname(__FILE__))
fancy_require "lib/boot"
main = File.expand_path(ARGV.shift)
fancy_require main

