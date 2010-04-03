#ifndef _FUNCALL_H_
#define _FUNCALL_H_

struct call_arg_node {
public:
  Identifier_p argname;
  Expression_p argexpr;
  call_arg_node *next;
};

class MethodCall : public Expression
{
 public:
  MethodCall(Expression_p receiver, call_arg_node *method_args);
  MethodCall(Expression_p receiver, Identifier_p method_ident);
  ~MethodCall();

  virtual FancyObject_p eval(Scope *scope);
  virtual OBJ_TYPE type() const;

 private:
  void init_method_ident();

  Expression_p receiver;
  Identifier_p method_ident;
  list< pair<Identifier_p, Expression_p> > arg_expressions;
};

typedef MethodCall* MethodCall_p;

#endif /* _FUNCALL_H_ */
