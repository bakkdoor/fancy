#include "self.h"
#include "../../scope.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      Self* Self::_self_node = NULL;
      Self* Self::node()
      {
        return _self_node;
      }

      void Self::init()
      {
        if(!_self_node) {
          _self_node = new Self();
        }
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
