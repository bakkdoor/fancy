#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include <sstream>

#include "message_send.h"
#include "../../scope.h"
#include "../../bootstrap/core_classes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      MessageSend::MessageSend(Expression* receiver,
                               send_arg_node *method_args) :
        _receiver(receiver),
        _method_cache(NULL),
        _class_cache(NULL),
        _metaclass_cache(NULL),
        _has_metaclass(false)
      {
        for(send_arg_node *tmp = method_args; tmp != NULL; tmp = tmp->next) {
          _arg_expressions.push_front(pair<Identifier*, Expression*>(tmp->argname, tmp->argexpr));
        }

        init_method_ident();
      }

      MessageSend::MessageSend(Expression* receiver, Identifier* method_ident) :
        _receiver(receiver),
        _method_ident(method_ident),
        _method_cache(NULL),
        _class_cache(NULL),
        _metaclass_cache(NULL),
        _has_metaclass(false)
      {
      }

      FancyObject* MessageSend::eval(Scope *scope)
      {
        int size = _arg_expressions.size();
        FancyObject* *args = new FancyObject*[size];
        int i = 0;
        list< pair<Identifier*, Expression*> >::iterator it;
        for(it = _arg_expressions.begin(); it != _arg_expressions.end() && i < size; it++) {
          args[i] = it->second->eval(scope);
          i++;
        }

        FancyObject* retval = nil;
        scope->set_current_sender(scope->current_self());

        // check for super send
        if(_receiver->type() == EXP_SUPER) {
          retval = scope->current_self()->send_super_message(_method_ident->name(), args, size, scope, scope->current_self());
        } else {
          // if no super send, do normal message send
          FancyObject* receiver_obj = _receiver->eval(scope);
          Class* receiver_class = receiver_obj->get_class();
          Class* receiver_metaclass = NULL;
          if(receiver_obj->has_metaclass()) {
            receiver_metaclass = receiver_obj->metaclass();
          }
          // check the class & method cache
          if(_class_cache && _receiver_cache && _method_cache
             && _class_cache == receiver_class
             && _receiver_cache == receiver_obj
             && _metaclass_cache == receiver_metaclass) {
            retval = _method_cache->call(receiver_obj, args, size, scope, scope->current_self());
          } else {
            // receiver object or class changed -> cache invalidated
            _receiver_cache = receiver_obj;
            _class_cache = receiver_class;
            _method_cache = receiver_obj->get_method(_method_ident->name());

            if(receiver_obj->has_metaclass()) {
              _metaclass_cache = receiver_obj->metaclass();
              _has_metaclass = true;
            } else {
              _metaclass_cache = NULL;
              _has_metaclass = false;
            }

            if(_method_cache) {
              // register as method cache
              receiver_class->add_cache(_method_ident->name(), this);
              if(receiver_metaclass) {
                receiver_metaclass->add_cache(_method_ident->name(), this);
              }

              retval = _method_cache->call(receiver_obj, args, size, scope, scope->current_self());
            } else {
              // no method found -> handle unknown message
              retval = receiver_obj->handle_unknown_message(_method_ident->name(), args, size, scope, scope->current_self());
            }
          }
        }
        delete[] args;
        return retval;
      }

      string MessageSend::to_sexp() const
      {
        stringstream s;

        s << "['message_send, " << _receiver->to_sexp() << ", ";
        s << _method_ident->to_sexp() << ", ";
        s << "[";

        int count = 1;
        int size = _arg_expressions.size();
        list< pair<Identifier*, Expression*> >::const_iterator it;
        for(it = _arg_expressions.begin(); it != _arg_expressions.end(); it++) {
          s << it->second->to_sexp();
          if(count < size) {
            s << ", ";
          }
          count++;
        }
        s << "]]";

        return s.str();
      }

      void MessageSend::init_method_ident()
      {
        stringstream str;
        list< pair<Identifier*, Expression*> >::iterator it;
        for(it = _arg_expressions.begin(); it != _arg_expressions.end(); it++) {
          str << it->first->name();
          str << ":";
        }

        _method_ident = Identifier::from_string(str.str());
      }

      void MessageSend::invalidate_cache()
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
