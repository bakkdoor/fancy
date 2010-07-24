#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include "super.h"
#include "../../bootstrap/core_classes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      Super::Super()
      {
      }

      FancyObject* Super::eval(Scope *scope)
      {
        // we simply return nil, since this value isn't needed.
        // see MethodCall#eval() for dealing with super method calls.
        return nil;
      }

    }
  }
}
