class Fancy {
  class Compiler Command {
    def self run: argv {
      batch = argv delete("--batch")
      print = argv delete("-B")
      argv each: |f| { compile: f info: batch print: print }
    }

    def self compile: file info: info (false) print: print (false) {
      info if_do: { "Compiling " ++ file . println }
      Compiler compile_file: file to: nil line: 1 print: print
    }
  }
}
