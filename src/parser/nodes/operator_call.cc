#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      OperatorCall::OperatorCall(Expression_p receiver,
                                 Identifier_p operator_name,
                                 Expression_p operand) :
        receiver(receiver),
        operator_name(operator_name),
        operand(operand)
      {
        assert(receiver);
        assert(operator_name);
        assert(operand);
      }

      OperatorCall::~OperatorCall()
      {
      }

      FancyObject_p OperatorCall::eval(Scope *scope)
      {
        // FancyObject_p self = scope->current_self();
        list<FancyObject_p> args;
        args.push_back(this->operand->eval(scope));

        FancyObject_p receiver_obj = receiver->eval(scope);
        return receiver_obj->call_method(this->operator_name->name(), args, scope);
      }

      OBJ_TYPE OperatorCall::type() const
      {
        return OBJ_OPCALL;
      }

    }
  }
}
