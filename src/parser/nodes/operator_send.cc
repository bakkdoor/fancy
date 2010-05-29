#include <cassert>
#include "operator_send.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      OperatorSend::OperatorSend(Expression* receiver,
                                 Identifier* operator_name,
                                 Expression* operand) :
        _receiver(receiver),
        _operator_name(operator_name),
        _operand(operand)
      {
        assert(receiver);
        assert(operator_name);
        assert(operand);
      }

      OperatorSend::~OperatorSend()
      {
      }

      FancyObject* OperatorSend::eval(Scope *scope)
      {
        // FancyObject* self = scope->current_self();
        FancyObject* args[1] = { _operand->eval(scope) };
        FancyObject* receiver_obj = _receiver->eval(scope);
        return receiver_obj->call_method(_operator_name->name(), args, 1, scope);
      }

      EXP_TYPE OperatorSend::type() const
      {
        return EXP_OPCALL;
      }

    }
  }
}
