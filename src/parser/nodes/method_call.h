#ifndef _FUNCALL_H_
#define _FUNCALL_H_

class MethodCall : public NativeObject
{
 public:
  MethodCall(Expression_p receiver, list< pair<Identifier_p, Expression_p> > method_arg_expr);
  MethodCall(Expression_p receiver, Identifier_p method_ident);
  ~MethodCall();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;

 private:
  Expression_p receiver;
  Identifier_p method_ident;
  list< pair<Identifier_p, Expression_p> > arg_expressions;

  NativeObject_p eval_lambda_call(NativeObject_p func_obj, Scope *scope);
  void init_method_ident();
};

typedef MethodCall* MethodCall_p;

#endif /* _FUNCALL_H_ */
