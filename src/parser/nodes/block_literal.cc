#include "block_literal.h"
#include "../../block.h"
#include "../../lexical_scope.h"
#include <cassert>

namespace fancy {
  namespace parser {
    namespace nodes {

      BlockLiteral::BlockLiteral(ExpressionList* body) :
        _body(body)
      {
      }

      BlockLiteral::BlockLiteral(block_arg_node *argnames, ExpressionList* body) :
        _body(body)
      {
        for(block_arg_node *tmp = argnames; tmp != NULL; tmp = tmp->next) {
          _argnames.push_front(tmp->argname);
        }
      }

      FancyObject* BlockLiteral::eval(Scope *scope)
      {
        LexicalScope* lex = new LexicalScope(scope);
        return new Block(_argnames, _body, lex);
      }

    }
  }
}
