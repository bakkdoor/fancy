#ifndef _CLASS_OPERATOR_DEFINITION_H_
#define _CLASS_OPERATOR_DEFINITION_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      class ClassOperatorDefExpr : public Expression
      {
      public:
        ClassOperatorDefExpr(Identifier_p class_name, Identifier_p op_name, Method_p method);

        virtual OBJ_TYPE type() const;
        virtual FancyObject_p eval(Scope *scope);
 
      private:
        Identifier_p _class_name;
        Identifier_p _op_name;
        Method_p _method;
      };

    }
  }
}

#endif /* _CLASS_OPERATOR_DEFINITION_H_ */
