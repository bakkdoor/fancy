#ifndef _OPERATOR_DEFINITION_H_
#define _OPERATOR_DEFINITION_H_

#include "../../expression.h"
#include "../../method.h"
#include "identifier.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      class OperatorDefExpr : public Expression
      {
      public:
        OperatorDefExpr(Identifier* op_name, Method* method);

        virtual EXP_TYPE type() const;
        virtual FancyObject* eval(Scope *scope);
 
      private:
        Identifier* _op_name;
        Method* _method;
      };

    }
  }
}

#endif /* _OPERATOR_DEFINITION_H_ */
