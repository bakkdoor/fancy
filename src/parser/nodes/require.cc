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

      string RequireStatement::to_sexp() const
      {
        return "[:require, \"" + _filename + "\"]";
      }

    }
  }
}
