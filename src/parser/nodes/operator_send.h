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
        virtual ~OperatorSend() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const { return EXP_OPSEND; }
        virtual string to_sexp() const;

      private:
        Expression* _receiver;
        Identifier* _operator_name;
        Expression* _operand;
        Callable* _method_cache;
        Class* _class_cache;
        FancyObject* _receiver_cache;
        unsigned int _class_change_cache;
        unsigned int _receiver_change_cache;
      };

    }
  }
}

#endif /* _OPERATOR_SEND_H_ */
