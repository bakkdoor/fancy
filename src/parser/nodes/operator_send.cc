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
        _class_change_cache(0),
        _receiver_change_cache(0)
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
        if(_class_cache == receiver_class
           && !CHANGED(receiver_obj, _receiver_change_cache)
           && !CHANGED(receiver_class, _class_change_cache)) {
          if(_method_cache) {
            return _method_cache->call(receiver_obj, &operand, 1, scope, scope->current_self());
          }
        } else {
          // receiver object or class changed -> cache invalidated
          _class_cache = receiver_class;
          _method_cache = receiver_obj->get_method(_operator_name->name());
          _class_change_cache = receiver_class->change_num();
          _receiver_change_cache = receiver_obj->change_num();

          if(_method_cache) {
            return _method_cache->call(receiver_obj, &operand, 1, scope, scope->current_self());
          }
        }

        // no method found -> handle unknown message
        return receiver_obj->handle_unknown_message(_operator_name->name(), &operand, 1, scope, scope->current_self());
      }

      string OperatorSend::to_sexp() const
      {
        stringstream s;
        
        s << "[:operator_send, " << _receiver->to_sexp() << ", ";
        s << _operator_name->to_sexp() << ", ";
        s << "[" << _operand->to_sexp() << "]]";

        return s.str();
      }

    }
  }
}
