#include "self.h"
#include "../../scope.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      Self* Self::_self_node = NULL;
      Self* Self::node()
      {
        if(!_self_node) {
          _self_node = new Self();
        }
        return _self_node;
      }

      Self::Self() : Identifier("self")
      {
      }

      FancyObject* Self::eval(Scope *scope)
      {
        return scope->current_self();
      }

      EXP_TYPE Self::type() const
      {
        return EXP_SELF;
      }

    }
  }
}
