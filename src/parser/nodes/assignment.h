#ifndef _ASSIGNMENT_H_
#define _ASSIGNMENT_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      /**
       * Assignment expression class.
       * Used in the parser. 
       * When evaluated, sets the value of an identifier within the current
       * scope.
       */
      class AssignmentExpr : public Expression
      {
      public:
        AssignmentExpr(Identifier_p identifier, Expression_p value_expr);
        ~AssignmentExpr();
  
        virtual OBJ_TYPE type() const;
        virtual FancyObject_p eval(Scope *scope);

      private:
        Identifier_p    identifier;
        Expression_p  value_expr;
      };

      typedef AssignmentExpr* AssignmentExpr_p;

    }
  }
}

#endif /* _ASSIGNMENT_H_ */
