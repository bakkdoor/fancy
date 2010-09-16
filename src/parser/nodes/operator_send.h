#ifndef _OPERATOR_SEND_H_
#define _OPERATOR_SEND_H_

#include "../../expression.h"
#include "../../fancy_object.h"
#include "identifier.h"
#include "../../method_cache.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      class OperatorSend : public Expression, public MethodCache
      {
      public:
        OperatorSend(Expression* receiver, Identifier* operator_name, Expression* operand);
        virtual ~OperatorSend() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const { return EXP_OPSEND; }
        virtual string to_sexp() const;

        virtual void invalidate_cache();

        virtual void set_enclosing_method(Method* method);

      private:
        Expression* _receiver;
        Identifier* _operator_name;
        Expression* _operand;
        Callable* _method_cache;
        Class* _class_cache;
        Class* _metaclass_cache;
        FancyObject* _receiver_cache;
        bool _has_metaclass;
      };

    }  }
}

#endif /* _OPERATOR_SEND_H_ */
