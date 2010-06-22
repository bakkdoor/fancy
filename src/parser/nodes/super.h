#ifndef _PARSER_NODES_SUPER_H_
#define _PARSER_NODES_SUPER_H_

#include "../../expression.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      class Super : public Expression
      {
      public:
        Super();
        virtual ~Super();

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const;
        virtual string to_sexp() const;
      };

    }
  }
}

#endif /* _PARSER_NODES_SUPER_H_ */
