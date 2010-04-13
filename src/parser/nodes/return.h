#ifndef _PARSER_NODES_RETURN_H_
#define _PARSER_NODES_RETURN_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      class ReturnStatement : public Expression
      {
      public:
        ReturnStatement(Expression_p return_expr);
        virtual ~ReturnStatement();

        virtual OBJ_TYPE type() const;
        virtual FancyObject* eval(Scope *scope);

      private:
        Expression_p _return_expr;
      };

    }
  }
}

#endif /* _PARSER_NODES_RETURN_H_ */
