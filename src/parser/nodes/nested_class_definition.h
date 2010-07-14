#ifndef _NESTED_CLASS_DEFINITION_H_
#define _NESTED_CLASS_DEFINITION_H_

#include "class_definition.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      class NestedClassDefExpr : public Expression
      {
      public:
        NestedClassDefExpr(ClassDefExpr* class_def);
        virtual ~NestedClassDefExpr() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const { return EXP_CLASSDEFEXPR; }

      private:
        ClassDefExpr* _class_def;
      };

    }
  }
}

#endif /* _NESTED_CLASS_DEFINITION_H_ */
