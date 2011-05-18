class Fancy AST {
  class Node : Rubinius AST Node {
    define_method('bytecode) |g| {
      bytecode: g
    }
  }
}
