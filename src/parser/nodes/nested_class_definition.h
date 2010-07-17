#ifndef _NESTED_CLASS_DEFINITION_H_
#define _NESTED_CLASS_DEFINITION_H_

#include "class_definition.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      class NestedClassDefExpr : public Expression
      {
      public:
        NestedClassDefExpr(Expression* class_def_expr);
        virtual ~NestedClassDefExpr() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const { return EXP_CLASSDEFEXPR; }
	virtual string to_sexp() const { return _class_def->to_sexp(); }

      private:
        ClassDefExpr* _class_def;
      };

    }
  }
}

#endif /* _NESTED_CLASS_DEFINITION_H_ */
