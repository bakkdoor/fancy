class Fancy CodeLoader {
  def self load_path {
    @@load_path
  }

  def self push_loadpath: path {
    push_loadpath(path)
  }

  def self load_compiled_file: file {
    load_compiled_file(file)
  }
}
