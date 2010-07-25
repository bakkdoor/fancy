#include "../../vendor/gc/include/gc.h"
#include "../../vendor/gc/include/gc_cpp.h"
#include "../../vendor/gc/include/gc_allocator.h"

#include "includes.h"

#include "../method.h"
#include "../native_method.h"
#include "../string.h"
#include "../number.h"

namespace fancy {
  namespace bootstrap {

    void init_method_class()
    {
      DEF_METHOD(MethodClass,
                 "name",
                 "Returns the name of a Method as a String.",
                 name);

      DEF_METHOD(MethodClass,
                 "argcount",
                 "Returns amount of arguments the Method takes.",
                 argcount);
    }

    METHOD(MethodClass, name)
    {
      if(Method* method = dynamic_cast<Method*>(self)) {
        return FancyString::from_value(method->name());
      } else if(NativeMethod* method = dynamic_cast<NativeMethod*>(self)) {
        return FancyString::from_value(method->identifier());
      } else {
        return nil;
      }
    }

    METHOD(MethodClass, argcount)
    {
      if(Method* method = dynamic_cast<Method*>(self)) {
        return Number::from_int(method->argcount());
      } else {
        return nil;
      }
    }
  }
}
