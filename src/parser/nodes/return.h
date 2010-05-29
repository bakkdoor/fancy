#ifndef _PARSER_NODES_RETURN_H_
#define _PARSER_NODES_RETURN_H_

#include "../../expression.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      class ReturnStatement : public Expression
      {
      public:
        ReturnStatement(Expression* return_expr);
        virtual ~ReturnStatement();

        virtual EXP_TYPE type() const;
        virtual FancyObject* eval(Scope *scope);

      private:
        Expression* _return_expr;
      };

    }
  }
}

#endif /* _PARSER_NODES_RETURN_H_ */
