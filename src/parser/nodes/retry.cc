#include "retry.h"
#include "../../bootstrap/core_classes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      FancyObject* Retry::eval(Scope *scope)
      {
        throw retry();
      }

      string Retry::to_sexp() const
      {
        return "['retry]";
      }

    }
  }
}
