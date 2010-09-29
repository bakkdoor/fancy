#ifndef _PARSER_NODES_RETURN_H_
#define _PARSER_NODES_RETURN_H_

#include "../../expression.h"

namespace fancy {

  class Method;

  namespace parser {
    namespace nodes {

      struct return_value {
        Method* enclosing_method;
        FancyObject* return_value;
      };

      struct local_return_value {
        FancyObject* return_value;
      };

      class ReturnStatement : public Expression
      {
      public:
        ReturnStatement(Expression* return_expr);
        ReturnStatement(Expression* return_expr, bool is_local);
        virtual ~ReturnStatement() {}

        virtual EXP_TYPE type() const { return EXP_RETURNSTATEMENT; }
        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;

      private:
        Expression* _return_expr;
        bool _is_local;
      };

    }
  }
}

#endif /* _PARSER_NODES_RETURN_H_ */
