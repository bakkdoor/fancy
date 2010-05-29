#include <map>

#include "assignment.h"
#include "../../scope.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      AssignmentExpr::AssignmentExpr(Identifier* identifier, Expression* value_expr) :
        _identifier(identifier), _value_expr(value_expr)
      {
      }

      AssignmentExpr::~AssignmentExpr()
      {
      }

      EXP_TYPE AssignmentExpr::type() const
      {
        return EXP_ASSIGNEXPR;
      }

      FancyObject* AssignmentExpr::eval(Scope *scope)
      {
        FancyObject* value = _value_expr->eval(scope);
        scope->define(_identifier->name(), value);
        return value;
      }

    }
  }
}
