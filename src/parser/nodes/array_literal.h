#ifndef _ARRAY_LITERAL_H_
#define _ARRAY_LITERAL_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      /**
       * ArrayLiteral class for Array literal values.
       * When evaluated, returns an instance of ArrayClass.
       * Only used within parser.
       */
      class ArrayLiteral : public Expression
      {
      public:
        ArrayLiteral(expression_node *expr_list);
        virtual ~ArrayLiteral();

        virtual FancyObject_p eval(Scope *scope);
        virtual EXP_TYPE type() const;

      private:
        list<Expression_p> _expressions;
      };

    }
  }
}
#endif /* _ARRAY_LITERAL_H_ */
