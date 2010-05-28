#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      RequireStatement::RequireStatement(String_p filename)
      {
        assert(filename);
        _filename = filename->value();
      }

      RequireStatement::~RequireStatement()
      {
      }

      EXP_TYPE RequireStatement::type() const
      {
        return EXP_REQUIRESTATEMENT;
      }

      FancyObject* RequireStatement::eval(Scope *scope)
      {
        parse_file(_filename);
        return nil;
      }

    }
  }
}
