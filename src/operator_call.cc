#include "includes.h"

OperatorCall::OperatorCall(Expression_p receiver,
                         Identifier_p operator_name,
                         Expression_p operand) :
  NativeObject(OBJ_OPCALL),
  receiver(receiver),
  operator_name(operator_name),
  operand(operand)
{
  assert(receiver);
  assert(operator_name);
  assert(operand);
}

OperatorCall::~OperatorCall()
{
}


NativeObject_p OperatorCall::equal(const NativeObject_p other) const
{
  // TODO: implement OperatorCall#equal
  return nil;
}

FancyObject_p OperatorCall::eval(Scope *scope)
{
  FancyObject_p self = scope->current_self();
  vector<Expression_p> args;
  args.push_back(this->operand);

  return self->call_method(this->operator_name->name(), args);
}

string OperatorCall::to_s() const
{
  return "<opcall>";
}
