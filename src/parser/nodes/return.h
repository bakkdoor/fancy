#ifndef _PARSER_NODES_RETURN_H_
#define _PARSER_NODES_RETURN_H_

class ReturnStatement : public NativeObject
{
public:
  ReturnStatement(Expression_p return_expr);
  virtual ~ReturnStatement();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;
  virtual FancyObject* eval(Scope *scope);

private:
  Expression_p _return_expr;
};

#endif /* _PARSER_NODES_RETURN_H_ */
