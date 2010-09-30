
def class Rubinius {
  def class Compiler {

    read_write_slots: ['parser, 'generator]

    def self compile_file: filename {
      compiler = new: 'file to: 'compiled_file
      compiler parser input: filename line: 1
      compiler run
    }

    def initialize: first to: last {
      @stage = Compiler::Stage from: first to: last with: self
    }

    def run {
      @stage run
    }

  }
}


