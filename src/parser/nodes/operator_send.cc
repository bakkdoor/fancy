#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      OperatorSend::OperatorSend(Expression_p receiver,
                                 Identifier_p operator_name,
                                 Expression_p operand) :
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

      FancyObject_p OperatorSend::eval(Scope *scope)
      {
        // FancyObject_p self = scope->current_self();
        FancyObject_p args[1] = { this->_operand->eval(scope) };
        FancyObject_p receiver_obj = this->_receiver->eval(scope);
        return receiver_obj->call_method(this->_operator_name->name(), args, 1, scope);
      }

      OBJ_TYPE OperatorSend::type() const
      {
        return OBJ_OPCALL;
      }

    }
  }
}
