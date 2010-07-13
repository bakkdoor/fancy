#include <cassert>
#include "operator_send.h"
#include "../../scope.h"
#include "../../class.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      OperatorSend::OperatorSend(Expression* receiver,
                                 Identifier* operator_name,
                                 Expression* operand) :
        _receiver(receiver),
        _operator_name(operator_name),
        _operand(operand),
        _method_cache(NULL),
        _class_cache(NULL)
      {
        // assert(receiver);
        // assert(operator_name);
        // assert(operand);
      }

      FancyObject* OperatorSend::eval(Scope *scope)
      {
        FancyObject* receiver_obj = _receiver->eval(scope);
        Class* receiver_class = receiver_obj->get_class();
        FancyObject* operand = _operand->eval(scope);

        scope->set_current_sender(scope->current_self());

        // check for class cache
        if(_class_cache == receiver_class && !receiver_obj->changed() && !receiver_class->changed()) {
          if(_method_cache) {
            return _method_cache->call(receiver_obj, &operand, 1, scope, scope->current_self());
          }
        } else {
          // receiver object or class changed -> cache invalidated
          _class_cache = receiver_class;
          _method_cache = receiver_obj->get_method(_operator_name->name());
          receiver_class->set_changed(false);
          receiver_obj->set_changed(false);
          
          if(_method_cache) {
            return _method_cache->call(receiver_obj, &operand, 1, scope, scope->current_self());
          }
        }

        // default, slower behaviour
        return receiver_obj->send_message(_operator_name->name(), &operand, 1, scope, scope->current_self());
      }

    }
  }
}
