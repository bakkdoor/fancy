#ifndef _FUNCALL_H_
#define _MESSAGE_SEND_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      struct send_arg_node {
      public:
        Identifier_p argname;
        Expression_p argexpr;
        send_arg_node *next;
      };

      class MessageSend : public Expression
      {
      public:
        MessageSend(Expression_p receiver, send_arg_node *message_args);
        MessageSend(Expression_p receiver, Identifier_p method_ident);
        ~MessageSend();

        virtual FancyObject_p eval(Scope *scope);
        virtual OBJ_TYPE type() const;

      private:
        void init_method_ident();

        Expression_p receiver;
        Identifier_p method_ident;
        list< pair<Identifier_p, Expression_p> > arg_expressions;
      };

      typedef MessageSend* MessageSend_p;

    }
  }
}

#endif /* _MESSAGE_SEND_H_ */
