#include "includes.h"

void init_hash_class()
{
  HashClass->def_class_method("new", new NativeMethod("new", class_method_Hash_new));
  HashClass->def_method("size", new NativeMethod("size", method_Hash_size));
}

/**
 * Hash class methods
 */
FancyObject_p class_method_Hash_new(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  return new Hash();
}

/**
 * Hash instance methods
 */

FancyObject_p method_Hash_size(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  Hash_p hash = dynamic_cast<Hash_p>(self);
  return Number::from_int(hash->size());
}
