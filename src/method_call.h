#ifndef _FUNCALL_H_
#define _FUNCALL_H_

class MethodCall : public Object
{
 public:
  MethodCall(Object_p receiver, Identifier_p method_identifier, Array_p arg_expressions);
  MethodCall(Object_p receiver, Method_p method, Array_p arg_expressions);
  ~MethodCall();

  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;

 private:
  Object_p receiver;
  Identifier_p method_ident;
  Method_p method;
  /* vector<Object_p> arg_expressions; */
  Array_p arg_expressions;

  Object_p eval_lambda_call(Object_p func_obj, Scope *scope);
};

typedef MethodCall* MethodCall_p;

#endif /* _FUNCALL_H_ */
