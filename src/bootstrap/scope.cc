#include "includes.h"

void init_scope_class()
{
  ScopeClass->def_method("define:value:", new NativeMethod("define:value:", method_Scope_define__value, 2));
  ScopeClass->def_method("parent", new NativeMethod("parent", method_Scope_parent));
}

/**
 * Scope instance methods
 */
FancyObject_p method_Scope_define__value(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p name = args.front();
  args.pop_front();
  FancyObject_p value = args.front();
  Scope* scope_obj = dynamic_cast<Scope*>(self);

  if(IS_STRING(name) || IS_SYMBOL(name)) {
    scope_obj->define(name->to_s(), value);
    return value;
  } else {
    errorln("Scope#define:value: expects either String or Symbol as first parameter.");
    return nil;
  }
}

FancyObject_p method_Scope_parent(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(scope->parent_scope()) {
    return scope->parent_scope();
  }
  return nil;
}
