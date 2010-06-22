#ifndef _CLASS_OPERATOR_DEFINITION_H_
#define _CLASS_OPERATOR_DEFINITION_H_

#include "../../expression.h"
#include "../../method.h"
#include "identifier.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      class ClassOperatorDefExpr : public Expression
      {
      public:
        ClassOperatorDefExpr(Identifier* class_name, Identifier* op_name, Method* method);
        virtual ~ClassOperatorDefExpr() {}

        virtual EXP_TYPE type() const;
        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;
 
      protected:
        Identifier* _class_name;
        Identifier* _op_name;
        Method* _method;
      };

      class PrivateClassOperatorDefExpr : public ClassOperatorDefExpr
      {
      public:
        PrivateClassOperatorDefExpr(Identifier* class_name, Identifier* op_name, Method* method);
        virtual ~PrivateClassOperatorDefExpr() {}

        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;
      };

      class ProtectedClassOperatorDefExpr : public ClassOperatorDefExpr
      {
      public:
        ProtectedClassOperatorDefExpr(Identifier* class_name, Identifier* op_name, Method* method);
        virtual ~ProtectedClassOperatorDefExpr() {}

        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;
      };

    }
  }
}

#endif /* _CLASS_OPERATOR_DEFINITION_H_ */
