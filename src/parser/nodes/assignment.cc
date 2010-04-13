#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      AssignmentExpr::AssignmentExpr(Identifier_p identifier, Expression_p value_expr) :
        identifier(identifier), value_expr(value_expr)
      {
      }

      AssignmentExpr::~AssignmentExpr()
      {
      }

      OBJ_TYPE AssignmentExpr::type() const
      {
        return OBJ_ASSIGNEXPR;
      }

      FancyObject_p AssignmentExpr::eval(Scope *scope)
      {
        FancyObject_p value = this->value_expr->eval(scope);
        scope->define(this->identifier->name(), value);
        return value;
      }

    }
  }
}
