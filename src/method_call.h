#ifndef _FUNCALL_H_
#define _FUNCALL_H_

class MethodCall : public Object
{
 public:
  MethodCall(Expression_p receiver, list< pair<Identifier_p, Expression_p> > method_arg_expr);
  /* MethodCall(Object_p receiver, Method_p method, list< pair<Identifier_p, Expression_p> > method_arg_expr); */
  MethodCall(Expression_p receiver, Identifier_p method_ident);
  ~MethodCall();

  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;

 private:
  Expression_p receiver;
  Identifier_p method_ident;
  Method_p method;
  list< pair<Identifier_p, Expression_p> > arg_expressions;

  Object_p eval_lambda_call(Object_p func_obj, Scope *scope);
};

typedef MethodCall* MethodCall_p;

#endif /* _FUNCALL_H_ */
