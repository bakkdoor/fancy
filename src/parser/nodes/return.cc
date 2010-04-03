#include "includes.h"

ReturnStatement::ReturnStatement(Expression_p return_expr) :
  _return_expr(return_expr)
{
}

ReturnStatement::~ReturnStatement()
{
}

OBJ_TYPE ReturnStatement::type() const
{
  return OBJ_RETURNSTATEMENT;
}

FancyObject* ReturnStatement::eval(Scope *scope)
{
  FancyObject_p retval = _return_expr->eval(scope);
  return retval;
}

