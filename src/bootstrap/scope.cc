#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_scope_class()
    {
      DEF_METHOD(ScopeClass,
                 "define:value:",
                 "Defines an Identifier with a given value in the Scope.",
                 define__value);

      DEF_METHOD(ScopeClass,
                 "parent",
                 "Returns the parent scope (or nil, if not defined).",
                 parent);

      DEF_METHOD(ScopeClass,
                 "get:",
                 "Returns the value for a given Identifier.",
                 get);
    }

    /**
     * Scope instance methods
     */
    METHOD(ScopeClass, define__value)
    {
      EXPECT_ARGS("Scope#define:value:", 2);
      FancyObject_p name = args[0];
      FancyObject_p value = args[1];
      Scope* scope_obj = dynamic_cast<Scope*>(self);

      if(IS_STRING(name) || IS_SYMBOL(name)) {
        scope_obj->define(name->to_s(), value);
        return value;
      } else {
        errorln("Scope#define:value: expects either String or Symbol as first parameter.");
        return nil;
      }
    }

    METHOD(ScopeClass, parent)
    {
      if(scope->parent_scope()) {
        return scope->parent_scope();
      }
      return nil;
    }

    METHOD(ScopeClass, get)
    {
      EXPECT_ARGS("Scope#get:", 1);
      Scope *sc = dynamic_cast<Scope*>(self);
      if(sc) {
        if(IS_STRING(args[0]) || IS_SYMBOL(args[0])) {
          return sc->get(args[0]->to_s());
        } else {
          errorln("Scope#get: expects either String or Symbol value.");
        }
      }
      errorln("Calling Scope#get: on invalid value!");
      return nil;
    }

  }
}
