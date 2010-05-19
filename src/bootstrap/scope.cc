#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Scope instance methods
     */
    METHOD(Scope__define__value);
    METHOD(Scope__parent);
    METHOD(Scope__get);

    void init_scope_class()
    {
      ScopeClass->def_method("define:value:", new NativeMethod("define:value:", Scope__define__value));
      ScopeClass->def_method("parent", new NativeMethod("parent", Scope__parent));
      ScopeClass->def_method("get:", new NativeMethod("get:", Scope__get));
    }

    /**
     * Scope instance methods
     */
    METHOD(Scope__define__value)
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

    METHOD(Scope__parent)
    {
      if(scope->parent_scope()) {
        return scope->parent_scope();
      }
      return nil;
    }

    METHOD(Scope__get)
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
