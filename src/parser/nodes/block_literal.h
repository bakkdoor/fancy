#ifndef _BLOCK_LITERAL_H_
#define _BLOCK_LITERAL_H_

#include <list>

#include "../../expression.h"
#include "../../array.h"
#include "expression_list.h"
#include "identifier.h"

using namespace std;

namespace fancy {
  namespace parser {
    namespace nodes {

      struct block_arg_node {
      public:
        Identifier *argname;
        block_arg_node *next;
      };

      /**
       * BlockLiteral class used in the parser for literal Block values.
       * When evaluated, returns an instance of BlockClass.
       */
      class BlockLiteral : public Expression
      {
      public:
        BlockLiteral(ExpressionList* body);
        BlockLiteral(block_arg_node *argnames, ExpressionList* body);
        virtual ~BlockLiteral() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const { return EXP_BLOCKLITERAL; }

      private:
        list<Identifier*> _argnames;
        ExpressionList* _body;
      };

    }
  }
}

#endif /* _BLOCK_LITERAL_H_ */
