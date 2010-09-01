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

      RequireStatement::RequireStatement(FancyString* filename) :
        _filename_expr(NULL)
      {
        assert(filename);
        _filename = filename->value();
      }

      RequireStatement::RequireStatement(Expression* filename_expr) :
        _filename_expr(filename_expr)
      {
      }

      FancyObject* RequireStatement::eval(Scope *scope)
      {
        if(_filename_expr) {
          _filename = _filename_expr->eval(scope)->to_s();
        }
        parse_file(_filename);
        return nil;
      }

      string RequireStatement::to_sexp() const
      {
        if(_filename_expr) {
          return "['require, " + _filename_expr->to_sexp() + "]";
        } else {
          return "['require, ['string_lit, \"" + _filename + "\"]]";
        }
      }

    }
  }
}
