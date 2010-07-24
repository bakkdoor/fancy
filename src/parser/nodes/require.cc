#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include <cassert>

#include "require.h"
#include "../../bootstrap/core_classes.h"
#include "../parser.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      RequireStatement::RequireStatement(FancyString* filename)
      {
        assert(filename);
        _filename = filename->value();
      }

      FancyObject* RequireStatement::eval(Scope *scope)
      {
        parse_file(_filename);
        return nil;
      }

    }
  }
}
