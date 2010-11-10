class Fancy AST {

  class Node : Rubinius AST Node {
    bytecode = |g| { bytecode: g }
    define_method('bytecode, &bytecode)
  }

}
