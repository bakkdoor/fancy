#include <map>

#include "assignment.h"
#include "../../scope.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      AssignmentExpr::AssignmentExpr(Identifier* identifier, Expression* value_expr) :
        _identifier(identifier),
        _value_expr(value_expr),
        _multiple_assign(false)
      {
      }

      AssignmentExpr::AssignmentExpr(identifier_node* identifiers, expression_node* value_exprs) :
        _identifier(NULL),
        _value_expr(NULL),
        _multiple_assign(true)
      {
        identifier_node* tmp = identifiers;
        identifier_node* curr = tmp;
        while(tmp) {
          _identifiers.push_front(tmp->identifier);
          curr = tmp;
          tmp = tmp->next;
          delete curr;
        }

        expression_node* tmp_exp = value_exprs;
        expression_node* curr_exp = tmp_exp;
        while(tmp_exp) {
          _value_exprs.push_front(tmp_exp->expression);
          curr_exp = tmp_exp;
          tmp_exp = tmp_exp->next;
          delete curr_exp;
        }
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
        if(_multiple_assign) {
          list<Expression*>::iterator it_exp = _value_exprs.begin();
          list<Identifier*>::iterator it_ident = _identifiers.begin();
	  vector<FancyObject*> values(_value_exprs.size(), nil);
	  // first, evaluate all expressions and save the results
	  // in order to support stuff like: x, y = y, x
	  // which depends on evaluating all expressions first and only then
	  // binding the results to the identifiers in the scope
	  unsigned int i = 0;
	  while(it_exp != _value_exprs.end()) {
	    values[i] = (*it_exp)->eval(scope);
	    i++;
	    it_exp++;
	  }

	  i = 0;
          while(it_ident != _identifiers.end() && i < values.size()) {
            scope->define((*it_ident)->name(), values[i]);
            // move on
            it_ident++;
            i++;
          }
          // fill any left identifiers up with nil
          while(it_ident != _identifiers.end()) {
            scope->define((*it_ident)->name(), nil);
            it_ident++;
          }
          return t; // multiple assignment simply returns true
        } else {
          FancyObject* value = _value_expr->eval(scope);
          scope->define(_identifier->name(), value);
          return value;
        }
      }

    }
  }
}
