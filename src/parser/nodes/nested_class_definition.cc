#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include "nested_class_definition.h"
#include "../../class.h"
#include "../../utils.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      NestedClassDefExpr::NestedClassDefExpr(Expression* class_def_expr)
      {
        if(ClassDefExpr* class_def = dynamic_cast<ClassDefExpr*>(class_def_expr)) {
          _class_def = class_def;
        } else {
          throw "No ClassDefExpr given for NestedClassDefExpr!";
        }
      }

      FancyObject* NestedClassDefExpr::eval(Scope *scope)
      {
        if(Class* outer_class = dynamic_cast<Class*>(scope->current_self())) {
          Scope *class_eval_scope = new Scope(outer_class, scope);
          _class_def->set_nested(outer_class);
          FancyObject* class_obj = _class_def->eval(class_eval_scope);
          if(Class* nested_class = dynamic_cast<Class*>(class_obj)) {
            outer_class->add_nested_class(_class_def->class_name(), nested_class);
            return class_obj;
          }
          throw "Nested class is not an actual Class!";
        } else {
          throw "Not a NestedClassDefExpr!";
        }
      }

    }
  }
}
