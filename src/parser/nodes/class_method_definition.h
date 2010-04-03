#ifndef _CLASS_METHOD_DEFINITION_H_
#define _CLASS_METHOD_DEFINITION_H_

class ClassMethodDefExpr : public Expression
{
 public:
  ClassMethodDefExpr(Identifier_p class_name, Identifier_p method_name, Method_p method); // method takes no arguments
  ClassMethodDefExpr(Identifier_p class_name, list< pair<Identifier_p, Identifier_p> > args_with_name, Method_p method);

  virtual OBJ_TYPE type() const;
  virtual FancyObject_p eval(Scope *scope);
 
private:
  string method_name();
  Identifier_p _class_name;
  Identifier_p _method_name;
  Method_p _method;
  list< pair<Identifier_p, Identifier_p> > _method_args;
};

#endif /* _CLASS_METHOD_DEFINITION_H_ */
