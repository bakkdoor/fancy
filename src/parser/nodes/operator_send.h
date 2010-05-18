#ifndef _OPERATOR_SEND_H_
#define _OPERATOR_SEND_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      class OperatorSend : public Expression
      {
      public:
        OperatorSend(Expression_p receiver, Identifier_p operator_name, Expression_p operand);
        virtual ~OperatorSend();

        virtual FancyObject_p eval(Scope *scope);
        virtual OBJ_TYPE type() const;

      private:
        Expression_p _receiver;
        Identifier_p _operator_name;
        Expression_p _operand;
      };

    }
  }
}

#endif /* _OPERATOR_SEND_H_ */
