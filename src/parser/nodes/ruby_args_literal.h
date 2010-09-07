#ifndef _RUBY_ARGS_LITERAL_H_
#define _RUBY_ARGS_LITERAL_H_

#include "array_literal.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      /**
       * RubyArgsLiteral class for Array literal values.
       * When evaluated, returns an instance of ArrayClass.
       * Only used within parser.
       */
      class RubyArgsLiteral : public Expression
      {
      public:
        RubyArgsLiteral(Expression* array_lit);
        virtual ~RubyArgsLiteral() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const { return EXP_RBARGSLITERAL; }

        virtual string to_sexp() const;

      private:
        ArrayLiteral* _array_lit;
      };

    }
  }
}


#endif /* _RUBY_ARGS_LITERAL_H_ */
