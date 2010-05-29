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
        RequireStatement(String* filename);
        virtual ~RequireStatement();

        virtual EXP_TYPE type() const;
        virtual FancyObject* eval(Scope *scope);

      private:
        string _filename;
      };

    }
  }
}

#endif /* _PARSER_NODES_REQUIRE_H_ */
