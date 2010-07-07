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
        virtual ~RequireStatement() {}

        virtual EXP_TYPE type() const { return EXP_REQUIRESTATEMENT; }
        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;

      private:
        string _filename;
      };

    }
  }
}

#endif /* _PARSER_NODES_REQUIRE_H_ */
