class Fancy {
  class Compiler Command {

    def self option: argv flag: name {
      argv delete(name)
    }

    def self option: argv value: name {
      idx = argv index(name)
      idx if_do: {
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
        o = (out_path && src_path) . if_do: {
          f sub(src_path, out_path) + "c"
        } else: { nil }
        compile: f to: o info: batch print: print
      }
      batch if_do: { "Compiled " ++ (argv size()) ++ " files." . println }
    }

    def self compile: file to: to (nil) info: info (false) print: print (false) {
      info if_do: { "Compiling " ++ file . println }
      to if_do: { require("fileutils"); FileUtils mkdir_p(File dirname(to)) }
      Compiler compile_file: file to: to line: 1 print: print
    }
  }
}
