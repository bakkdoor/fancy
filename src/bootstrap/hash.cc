#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Hash class methods
     */
    METHOD(Hash_class__new);

    /**
     * Hash instance methods
     */

    METHOD(Hash__size);
    METHOD(Hash__at__put);
    METHOD(Hash__at);
    METHOD(Hash__keys);
    METHOD(Hash__values);

    void init_hash_class()
    {
      HashClass->def_class_method("new", new NativeMethod("new", Hash_class__new));
      HashClass->def_method("size", new NativeMethod("size", Hash__size));
      HashClass->def_method("at:put:", new NativeMethod("at:put:", Hash__at__put));
      HashClass->def_method("at:", new NativeMethod("at", Hash__at));
      HashClass->def_method("keys", new NativeMethod("keys", Hash__keys));
      HashClass->def_method("values", new NativeMethod("values", Hash__values));
    }

    /**
     * Hash class methods
     */
    METHOD(Hash_class__new)
    {
      return new Hash();
    }

    /**
     * Hash instance methods
     */

    METHOD(Hash__size)
    {
      Hash_p hash = dynamic_cast<Hash_p>(self);
      return Number::from_int(hash->size());
    }

    METHOD(Hash__at__put)
    {
      EXPECT_ARGS("Hash#at:put", 2);
      Hash_p hash = dynamic_cast<Hash_p>(self);
      FancyObject_p key = args[0];
      FancyObject_p value = args[1];
      hash->set_value(key, value);
      return self;
    }

    METHOD(Hash__at)
    {
      EXPECT_ARGS("Hash#at:", 1);
      Hash_p hash = dynamic_cast<Hash_p>(self);
      FancyObject_p key = args[0];
      return hash->get_value(key);
    }

    METHOD(Hash__keys)
    {
      Hash_p hash = dynamic_cast<Hash_p>(self);
      return new Array(hash->keys());
    }

    METHOD(Hash__values)
    {
      Hash_p hash = dynamic_cast<Hash_p>(self);
      return new Array(hash->values());
    }

  }
}
