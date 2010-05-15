#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      MethodCall::MethodCall(Expression_p receiver,
                             call_arg_node *method_args) :
        receiver(receiver)
      {
        for(call_arg_node *tmp = method_args; tmp != NULL; tmp = tmp->next) {
          arg_expressions.push_front(pair<Identifier_p, Expression_p>(tmp->argname, tmp->argexpr));
        }

        init_method_ident();
      }

      MethodCall::MethodCall(Expression_p receiver, Identifier_p method_ident) :
        receiver(receiver),
        method_ident(method_ident)
      {
      }

      MethodCall::~MethodCall()
      {
      }

      FancyObject_p MethodCall::eval(Scope *scope)
      {
        int size = arg_expressions.size();
        FancyObject_p *args = new FancyObject_p[size];
        int i = 0;
        list< pair<Identifier_p, Expression_p> >::iterator it;
        for(it = arg_expressions.begin(); it != arg_expressions.end() && i < size; it++) {
          args[i] = it->second->eval(scope);
          i++;
        }  
  
        FancyObject_p retval = nil;

        // check for super call
        if(receiver->type() == OBJ_SUPER) {
          retval = scope->current_self()->call_super_method(this->method_ident->name(), args, size, scope);
        } else {
          // if no super call, do normal method call
          FancyObject_p receiver_obj = receiver->eval(scope);
          retval = receiver_obj->call_method(this->method_ident->name(), args, size, scope);
        }
        delete[] args;
        return retval;
      }

      OBJ_TYPE MethodCall::type() const
      {
        return OBJ_METHODCALL;
      }

      void MethodCall::init_method_ident()
      {
        stringstream str;
        list< pair<Identifier_p, Expression_p> >::iterator it;
        for(it = this->arg_expressions.begin(); it != this->arg_expressions.end(); it++) {
          str << it->first->name();
          str << ":";
        }

        this->method_ident = Identifier::from_string(str.str());
      }

    }
  }
}
