#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

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
        _class_cache(NULL),
        _metaclass_cache(NULL),
        _has_metaclass(false)
      {
      }

      FancyObject* OperatorSend::eval(Scope *scope)
      {
        FancyObject* receiver_obj = _receiver->eval(scope);
        Class* receiver_class = receiver_obj->get_class();
        FancyObject* operand = _operand->eval(scope);
        Class* receiver_metaclass = NULL;
        if(receiver_obj->has_metaclass()) {
          receiver_metaclass = receiver_obj->metaclass();
        }

        scope->set_current_sender(scope->current_self());

        if(_method_cache && _class_cache && _receiver_cache
           && _class_cache == receiver_class
           && _receiver_cache == receiver_obj
           && _metaclass_cache == receiver_metaclass) {
          return _method_cache->call(receiver_obj, &operand, 1, scope, scope->current_self());
        } else {
          // receiver object or class changed -> cache invalidated
          _receiver_cache = receiver_obj;
          _class_cache = receiver_class;
          _method_cache = receiver_obj->get_method(_operator_name->name());

          if(receiver_obj->has_metaclass()) {
            _metaclass_cache = receiver_obj->metaclass();
            _has_metaclass = true;
          } else {
            _metaclass_cache = NULL;
            _has_metaclass = false;
          }

          if(_method_cache) {
            // register as method cache
            receiver_class->add_cache(_operator_name->name(), this);
            if(receiver_metaclass) {
              receiver_metaclass->add_cache(_operator_name->name(), this);
            }

            return _method_cache->call(receiver_obj, &operand, 1, scope, scope->current_self());
          }
        }

        // no method found -> handle unknown message
        return receiver_obj->handle_unknown_message(_operator_name->name(), &operand, 1, scope, scope->current_self());
      }

      string OperatorSend::to_sexp() const
      {
        stringstream s;

        s << "['operator_send, " << _receiver->to_sexp() << ", ";
        s << _operator_name->to_sexp() << ", ";
        s << _operand->to_sexp() << "]";

        return s.str();
      }

      void OperatorSend::invalidate_cache()
      {
        _method_cache = NULL;
        _class_cache = NULL;
        _receiver_cache = NULL;
        _metaclass_cache = NULL;
        _has_metaclass = false;
      }

    }
  }
}
