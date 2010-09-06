#ifndef _FUNCALL_H_
#define _MESSAGE_SEND_H_

#include <list>

#include "../../expression.h"
#include "identifier.h"
#include "../../callable.h"

using namespace std;

namespace fancy {

  class Class;

  namespace parser {
    namespace nodes {

      struct send_arg_node {
      public:
        Identifier* argname;
        Expression* argexpr;
        send_arg_node *next;
      };

      class MessageSend : public Expression
      {
      public:
        MessageSend(Expression* receiver, send_arg_node *message_args);
        MessageSend(Expression* receiver, Identifier* method_ident);
        ~MessageSend() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const { return EXP_MESSAGESEND; }
        virtual string to_sexp() const;

      private:
        void init_method_ident();

        Expression* _receiver;
        Identifier* _method_ident;
        list< pair<Identifier*, Expression*> > _arg_expressions;
        Callable* _method_cache;
        Class* _class_cache;
        FancyObject* _receiver_cache;
        unsigned int _class_change_cache;
        unsigned int _receiver_change_cache;
      };

    }
  }
}

#endif /* _MESSAGE_SEND_H_ */
