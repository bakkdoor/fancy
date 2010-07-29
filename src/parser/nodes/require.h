#ifndef _PARSER_NODES_REQUIRE_H_
#define _PARSER_NODES_REQUIRE_H_

#include <string>

#include "../../expression.h"
#include "../../string.h"
#include "identifier.h"

using namespace std;

namespace fancy {
  namespace parser {
    namespace nodes {

      class RequireStatement : public Expression
      {
      public:
        RequireStatement(FancyString* filename);
        RequireStatement(Expression* filename_expr);
        virtual ~RequireStatement() {}

        virtual EXP_TYPE type() const { return EXP_REQUIRESTATEMENT; }
        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;

      private:
        string _filename;
        Expression* _filename_expr;
      };

    }
  }
}

#endif /* _PARSER_NODES_REQUIRE_H_ */
