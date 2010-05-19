#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Hash class methods
     */
    FancyObject_p class_method_Hash_new(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

    /**
     * Hash instance methods
     */

    FancyObject_p method_Hash_size(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Hash_at__put(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Hash_at(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Hash_keys(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Hash_values(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

    void init_hash_class()
    {
      HashClass->def_class_method("new", new NativeMethod("new", class_method_Hash_new));
      HashClass->def_method("size", new NativeMethod("size", method_Hash_size));
      HashClass->def_method("at:put:", new NativeMethod("at:put:", method_Hash_at__put));
      HashClass->def_method("at:", new NativeMethod("at", method_Hash_at));
      HashClass->def_method("keys", new NativeMethod("keys", method_Hash_keys));
      HashClass->def_method("values", new NativeMethod("values", method_Hash_values));
    }

    /**
     * Hash class methods
     */
    FancyObject_p class_method_Hash_new(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      return new Hash();
    }

    /**
     * Hash instance methods
     */

    FancyObject_p method_Hash_size(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      Hash_p hash = dynamic_cast<Hash_p>(self);
      return Number::from_int(hash->size());
    }

    FancyObject_p method_Hash_at__put(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Hash#at:put", 2);
      Hash_p hash = dynamic_cast<Hash_p>(self);
      FancyObject_p key = args[0];
      FancyObject_p value = args[1];
      hash->set_value(key, value);
      return self;
    }

    FancyObject_p method_Hash_at(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Hash#at:", 1);
      Hash_p hash = dynamic_cast<Hash_p>(self);
      FancyObject_p key = args[0];
      return hash->get_value(key);
    }

    FancyObject_p method_Hash_keys(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      Hash_p hash = dynamic_cast<Hash_p>(self);
      return new Array(hash->keys());
    }

    FancyObject_p method_Hash_values(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      Hash_p hash = dynamic_cast<Hash_p>(self);
      return new Array(hash->values());
    }

  }
}
