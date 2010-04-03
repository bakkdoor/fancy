#ifndef _METHOD_DEFINITION_H_
#define _METHOD_DEFINITION_H_

class MethodDefExpr : public Expression
{
 public:
  MethodDefExpr(Identifier_p name, Method_p method); // method takes no arguments
  MethodDefExpr(list< pair<Identifier_p, Identifier_p> > args_with_name, Method_p method);

  virtual OBJ_TYPE type() const;
  virtual FancyObject_p eval(Scope *scope);
 
private:
  string method_name();
  list< pair<Identifier_p, Identifier_p> > method_args;
  Method_p method;
  Identifier_p _method_name;
};

#endif /* _METHOD_DEFINITION_H_ */
