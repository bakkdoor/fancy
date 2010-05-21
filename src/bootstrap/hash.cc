#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_hash_class()
    {
      DEF_CLASSMETHOD(HashClass,
                      "new",
                      "Hash constructor.",
                      new);

      DEF_METHOD(HashClass,
                 "size",
                 "Returns the size (amount of key-value pairs) of the Hash.",
                 size);

      DEF_METHOD(HashClass,
                 "at:put:",
                 "Sets the value for a key in the Hash.",
                 at__put);

      DEF_METHOD(HashClass,
                 "at:",
                 "Returns the value for a given key (or nil, if not defined).",
                 at);

      DEF_METHOD(HashClass,
                 "keys",
                 "Returns an Array with all keys defined in the Hash.",
                 keys);

      DEF_METHOD(HashClass,
                 "values",
                 "Returns an Array with all values defined in the Hash.",
                 values);
    }

    /**
     * Hash class methods
     */
    CLASSMETHOD(HashClass, new)
    {
      return new Hash();
    }

    /**
     * Hash instance methods
     */

    METHOD(HashClass, size)
    {
      Hash_p hash = dynamic_cast<Hash_p>(self);
      return Number::from_int(hash->size());
    }

    METHOD(HashClass, at__put)
    {
      EXPECT_ARGS("Hash#at:put", 2);
      Hash_p hash = dynamic_cast<Hash_p>(self);
      FancyObject_p key = args[0];
      FancyObject_p value = args[1];
      hash->set_value(key, value);
      return self;
    }

    METHOD(HashClass, at)
    {
      EXPECT_ARGS("Hash#at:", 1);
      Hash_p hash = dynamic_cast<Hash_p>(self);
      FancyObject_p key = args[0];
      return hash->get_value(key);
    }

    METHOD(HashClass, keys)
    {
      Hash_p hash = dynamic_cast<Hash_p>(self);
      return new Array(hash->keys());
    }

    METHOD(HashClass, values)
    {
      Hash_p hash = dynamic_cast<Hash_p>(self);
      return new Array(hash->values());
    }

  }
}
