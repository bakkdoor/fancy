#ifndef _METHOD_DEFINITION_H_
#define _METHOD_DEFINITION_H_

class MethodDefExpr : public NativeObject
{
 public:
  MethodDefExpr(Identifier_p name, Method_p method); // method takes no arguments
  MethodDefExpr(list< pair<Identifier_p, Identifier_p> > args_with_name, Method_p method);

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;
  virtual FancyObject_p eval(Scope *scope);
 
private:
  string method_name();
  list< pair<Identifier_p, Identifier_p> > method_args;
  Method_p method;
  Identifier_p _method_name;
};

#endif /* _METHOD_DEFINITION_H_ */
