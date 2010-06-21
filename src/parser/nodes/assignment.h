#ifndef _ASSIGNMENT_H_
#define _ASSIGNMENT_H_

#include "../../expression.h"
#include "expression_list.h"
#include "identifier.h"
#include "../../bootstrap/core_classes.h"

#include <list>
using namespace std;

namespace fancy {
  namespace parser {
    namespace nodes {

      struct identifier_node {
        Identifier* identifier;
        identifier_node* next;
      };

      /**
       * Assignment expression class.
       * Used in the parser. 
       * When evaluated, sets the value of an identifier within the current
       * scope.
       */
      class AssignmentExpr : public Expression
      {
      public:
        AssignmentExpr(Identifier* identifier, Expression* value_expr);
        AssignmentExpr(identifier_node* identifiers, expression_node* value_exprs);
        ~AssignmentExpr();
  
        virtual EXP_TYPE type() const;
        virtual FancyObject* eval(Scope *scope);

      private:
        Identifier*  _identifier;
        Expression*  _value_expr;
        bool _multiple_assign;
        list<Identifier*> _identifiers;
        list<Expression*> _value_exprs;
      };

    }
  }
}

#endif /* _ASSIGNMENT_H_ */
