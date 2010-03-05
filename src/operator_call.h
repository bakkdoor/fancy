#ifndef _OPERATOR_CALL_H_
#define _OPERATOR_CALL_H_

class OperatorCall : public NativeObject
{
public:
  OperatorCall(Expression_p receiver, Identifier_p operator_name, Expression_p operand);
  virtual ~OperatorCall();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual string to_s() const;

private:
  Expression_p receiver;
  Identifier_p operator_name;
  Expression_p operand;
};

#endif /* _OPERATOR_CALL_H_ */
