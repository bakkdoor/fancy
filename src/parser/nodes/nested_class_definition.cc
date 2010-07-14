#include "nested_class_definition.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      NestedClassDefExpr::NestedClassDefExpr(ClassDefExpr* class_def) :
        _class_def(class_def)
      {
      }

      FancyObject* NestedClassDefExpr::eval(Scope *scope)
      {
        if(Class* outer_klass = dynamic_cast<Class*>(scope->current_self())) {
          outer_klass->define_class_method(
        } else {
          throw "Not a NestedClassDefExpr!";
        }
      }

    }
  }
}
