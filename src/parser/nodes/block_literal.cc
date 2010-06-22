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

      BlockLiteral::~BlockLiteral()
      {
      }

      FancyObject* BlockLiteral::eval(Scope *scope)
      {
        LexicalScope* lex = new LexicalScope(scope);
        return new Block(_argnames, _body, lex);
      }

      EXP_TYPE BlockLiteral::type() const
      {
        return EXP_BLOCKLITERAL;
      }

      string BlockLiteral::to_sexp() const
      {
        stringstream s;

        s << "[:block_lit, [";
        int size = _argnames.size();
        int count = 1;
        for(list<Identifier*>::const_iterator it = _argnames.begin();
            it != _argnames.end();
            it++) {
          s << (*it)->to_sexp();
          if(count < size) {
            s << ", ";
          }
          count++;
        }
        s << "], "
          << _body->to_sexp()
          << "]";

        return s.str();
      }

    }
  }
}
