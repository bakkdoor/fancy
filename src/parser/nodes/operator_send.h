#ifndef _OPERATOR_SEND_H_
#define _OPERATOR_SEND_H_

#include "../../expression.h"
#include "../../fancy_object.h"
#include "identifier.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      class OperatorSend : public Expression
      {
      public:
        OperatorSend(Expression* receiver, Identifier* operator_name, Expression* operand);
        virtual ~OperatorSend();

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const;
        virtual string to_sexp() const;

      private:
        Expression* _receiver;
        Identifier* _operator_name;
        Expression* _operand;
      };

    }
  }
}

#endif /* _OPERATOR_SEND_H_ */
