#ifndef _OPERATOR_CALL_H_
#define _OPERATOR_CALL_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      class OperatorCall : public Expression
      {
      public:
        OperatorCall(Expression_p receiver, Identifier_p operator_name, Expression_p operand);
        virtual ~OperatorCall();

        virtual FancyObject_p eval(Scope *scope);
        virtual OBJ_TYPE type() const;

      private:
        Expression_p receiver;
        Identifier_p operator_name;
        Expression_p operand;
      };

    }
  }
}

#endif /* _OPERATOR_CALL_H_ */
