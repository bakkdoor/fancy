#ifndef _OPERATOR_DEFINITION_H_
#define _OPERATOR_DEFINITION_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      class OperatorDefExpr : public Expression
      {
      public:
        OperatorDefExpr(Identifier_p op_name, Method_p method);

        virtual OBJ_TYPE type() const;
        virtual FancyObject_p eval(Scope *scope);
 
      private:
        Identifier_p _op_name;
        Method_p _method;
      };

    }
  }
}

#endif /* _OPERATOR_DEFINITION_H_ */
