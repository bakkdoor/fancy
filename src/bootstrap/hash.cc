#include "includes.h"

void init_hash_class()
{
  HashClass->def_class_method("new", new NativeMethod("new", class_method_Hash_new));
  HashClass->def_method("size", new NativeMethod("size", method_Hash_size));
  HashClass->def_method("at:put:", new NativeMethod("at:put:", method_Hash_at__put, 2));
  HashClass->def_method("at:", new NativeMethod("at", method_Hash_at, 1));
  HashClass->def_method("keys", new NativeMethod("keys", method_Hash_keys));
  HashClass->def_method("values", new NativeMethod("values", method_Hash_values));
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

FancyObject_p method_Hash_at__put(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  EXPECT_ARGS("Hash#at:put", 2);
  Hash_p hash = dynamic_cast<Hash_p>(self);
  FancyObject_p key = args.front();
  args.pop_front();
  FancyObject_p value = args.front();
  hash->set_value(key, value);
  return self;
}

FancyObject_p method_Hash_at(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  EXPECT_ARGS("Hash#at:", 1);
  Hash_p hash = dynamic_cast<Hash_p>(self);
  FancyObject_p key = args.front();
  return hash->get_value(key);
}

FancyObject_p method_Hash_keys(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  Hash_p hash = dynamic_cast<Hash_p>(self);
  return new Array(hash->keys());
}

FancyObject_p method_Hash_values(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  Hash_p hash = dynamic_cast<Hash_p>(self);
  return new Array(hash->values());
}
