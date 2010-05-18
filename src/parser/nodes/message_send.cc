#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      MessageSend::MessageSend(Expression_p receiver,
                               send_arg_node *method_args) :
        _receiver(receiver)
      {
        for(send_arg_node *tmp = method_args; tmp != NULL; tmp = tmp->next) {
          _arg_expressions.push_front(pair<Identifier_p, Expression_p>(tmp->argname, tmp->argexpr));
        }

        init_method_ident();
      }

      MessageSend::MessageSend(Expression_p receiver, Identifier_p method_ident) :
        _receiver(receiver),
        _method_ident(method_ident)
      {
      }

      MessageSend::~MessageSend()
      {
      }

      FancyObject_p MessageSend::eval(Scope *scope)
      {
        int size = _arg_expressions.size();
        FancyObject_p *args = new FancyObject_p[size];
        int i = 0;
        list< pair<Identifier_p, Expression_p> >::iterator it;
        for(it = _arg_expressions.begin(); it != _arg_expressions.end() && i < size; it++) {
          args[i] = it->second->eval(scope);
          i++;
        }  
  
        FancyObject_p retval = nil;

        // check for super call
        if(_receiver->type() == OBJ_SUPER) {
          retval = scope->current_self()->call_super_method(this->_method_ident->name(), args, size, scope);
        } else {
          // if no super call, do normal method call
          FancyObject_p receiver_obj = _receiver->eval(scope);
          retval = receiver_obj->call_method(this->_method_ident->name(), args, size, scope);
        }
        delete[] args;
        return retval;
      }

      OBJ_TYPE MessageSend::type() const
      {
        return OBJ_METHODCALL;
      }

      void MessageSend::init_method_ident()
      {
        stringstream str;
        list< pair<Identifier_p, Expression_p> >::iterator it;
        for(it = this->_arg_expressions.begin(); it != this->_arg_expressions.end(); it++) {
          str << it->first->name();
          str << ":";
        }

        this->_method_ident = Identifier::from_string(str.str());
      }

    }
  }
}
