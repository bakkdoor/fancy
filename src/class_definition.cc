#include "includes.h"

ClassDefExpr::ClassDefExpr(Identifier_p class_name,
                           ExpressionList_p class_body) :
  NativeObject(OBJ_CLASSDEFEXPR),
  _superclass(ObjectClass),
  _superclass_name(0),
  _class_name(class_name),
  _class_body(class_body)
{
}

ClassDefExpr::ClassDefExpr(Identifier_p superclass_name,
                           Identifier_p class_name,
                           ExpressionList_p class_body) :
  NativeObject(OBJ_CLASSDEFEXPR),
  _superclass(0),
  _superclass_name(superclass_name),
  _class_name(class_name),
  _class_body(class_body)
{
}

ClassDefExpr::~ClassDefExpr()
{
}

NativeObject_p ClassDefExpr::equal(const NativeObject_p other) const
{
  // TODO: might need to implement this correctly...
  return nil;
}

FancyObject_p ClassDefExpr::eval(Scope *scope)
{
  Class_p superclass = this->_superclass;
  if(!superclass && this->_superclass_name) {
    FancyObject_p class_obj = scope->get(this->_superclass_name->name());
    if(class_obj->is_class()) {
      superclass = dynamic_cast<Class_p>(class_obj);
    } else {
      error("Superclass identifier does not reference a class: ") 
        << this->_superclass_name->name() 
        << "(" << class_obj->type() << ")"
        << endl;
      return nil;
    }
  }
  Class_p new_class = new Class(this->_class_name->name(), superclass);
  // create new scope with current_self set to new class
  Scope *class_eval_scope = new Scope(new_class, scope);
  this->_class_body->eval(class_eval_scope);
  scope->define(this->_class_name->name(), new_class);
  return new_class;
}

string ClassDefExpr::to_s() const
{
  return "<ClassDefinition>";
}

