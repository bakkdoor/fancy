#include "includes.h"

AssignmentExpr::AssignmentExpr(Identifier_p identifier, NativeObject_p value_expr) :
  NativeObject(OBJ_ASSIGNEXPR), identifier(identifier), value_expr(value_expr)
{
}

AssignmentExpr::~AssignmentExpr()
{
}
  
NativeObject_p AssignmentExpr::equal(const NativeObject_p other) const
{
  if(!IS_ASSIGNEXPR(other))
    return nil;

  AssignmentExpr_p other_assign = (AssignmentExpr_p)other;

  if((this->identifier->equal(other_assign->identifier) != nil)
     && (this->value_expr->equal(other_assign->value_expr) != nil))
    return t;

  return nil;
}

string AssignmentExpr::to_s() const
{
  return "<assignment>";
}

NativeObject_p AssignmentExpr::eval(Scope *scope)
{
  NativeObject_p value = this->value_expr->eval(scope);
  scope->define(this->identifier->name(), value);
  return value;
}

