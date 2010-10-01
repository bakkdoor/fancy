#ifndef _RETRY_H_
#define _RETRY_H_

#include "../../expression.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      class TryCatchBlock;

      struct retry {
      };

      class Retry : public Expression
      {
      public:
        Retry() {}
        virtual ~Retry() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const { return EXP_RETRY; }

        virtual string to_sexp() const;
      };

    }
  }
}

#endif /* _RETRY_H_ */
