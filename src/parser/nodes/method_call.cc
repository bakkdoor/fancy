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
        list< pair<Identifier_p, Expression_p> >::iterator it;
        list<FancyObject_p> args;
        for(it = arg_expressions.begin(); it != arg_expressions.end(); it++) {
          Expression_p exp = (*it).second;
          args.push_back(exp->eval(scope));
        }  
  
        FancyObject_p receiver_obj = receiver->eval(scope);
        return receiver_obj->call_method(this->method_ident->name(), args, scope);
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
