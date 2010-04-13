#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ClassDefExpr::ClassDefExpr(Identifier_p class_name,
                                 ExpressionList_p class_body) :
        _superclass(ObjectClass),
        _superclass_name(0),
        _class_name(class_name),
        _class_body(class_body)
      {
      }

      ClassDefExpr::ClassDefExpr(Identifier_p superclass_name,
                                 Identifier_p class_name,
                                 ExpressionList_p class_body) :
        _superclass(0),
        _superclass_name(superclass_name),
        _class_name(class_name),
        _class_body(class_body)
      {
      }

      ClassDefExpr::~ClassDefExpr()
      {
      }

      FancyObject_p ClassDefExpr::eval(Scope *scope)
      {
        Class_p the_class = 0;
        FancyObject_p class_obj = scope->get(this->_class_name->name());
        // check if class is already defined.
        // if so, don't create a new class
        if(IS_CLASS(class_obj)) {
          the_class = dynamic_cast<Class_p>(class_obj);
        } else {
          // if not yet defined, create a new class and define it in the
          // current scope
          Class_p superclass = this->_superclass;
          if(!superclass && this->_superclass_name) {
            FancyObject_p class_obj = scope->get(this->_superclass_name->name());
            if(IS_CLASS(class_obj)) {
              superclass = dynamic_cast<Class_p>(class_obj);
            } else {
              error("Superclass identifier does not reference a class: ") 
                << this->_superclass_name->name() 
                << "(" << class_obj->type() << ")"
                << endl;
              return nil;
            }
          }

          the_class = new Class(this->_class_name->name(), superclass);
          scope->define(this->_class_name->name(), the_class);
        }
        // create new scope with current_self set to new class
        // and eval the body of the class definition
        Scope *class_eval_scope = new Scope(the_class, scope);
        class_eval_scope->set_current_class(the_class);
        this->_class_body->eval(class_eval_scope);
        return the_class;
      }

      OBJ_TYPE ClassDefExpr::type() const
      {
        return OBJ_CLASSDEFEXPR;
      }

    }
  }
}
