#include "includes.h"

ReturnStatement::ReturnStatement(Expression_p return_expr) :
  NativeObject(),
  _return_expr(return_expr)
{
}

ReturnStatement::~ReturnStatement()
{
}

NativeObject_p ReturnStatement::equal(const NativeObject_p other) const
{
  return nil;
}

OBJ_TYPE ReturnStatement::type() const
{
  return OBJ_RETURNSTATEMENT;
}

string ReturnStatement::to_s() const
{
  return "<RETURNSTATEMENT>";
}

FancyObject* ReturnStatement::eval(Scope *scope)
{
  FancyObject_p retval = _return_expr->eval(scope);
  return retval;
}

