require("fileutils")

class Fancy {
  class Compiler Command {

    def self option: argv flag: name {
      argv delete(name)
    }

    def self option: argv value: name {
      idx = argv index(name)
      if: idx then: {
        value = argv delete_at(idx + 1)
        argv delete_at(idx)
        value
      } else: {
        nil
      }
    }

    def self run: argv {
      batch = option: argv flag: "--batch"
      print = option: argv flag: "-B"
      src_path = option: argv value: "--source-path"
      out_path = option: argv value: "--output-path"
      argv each() |f| {
        o = nil
        if: (out_path && src_path) then: {
          o = f sub(src_path, out_path) + "c"
        }
        compile: f to: o info: batch print: print
      }
      if: batch then: {
        "Compiled " ++ (argv size()) ++ " files." . println
      }
    }

    def self compile: file to: to (nil) info: info (false) print: print (false) {
      if: info then: {
        "Compiling " ++ file println
      }
      if: to then: {
        FileUtils mkdir_p(File dirname(to))
      }
      Compiler compile_file: file to: to line: 1 print: print
    }
  }
}
