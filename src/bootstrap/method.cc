#include "includes.h"

#include "../method.h"
#include "../native_method.h"
#include "../string.h"

namespace fancy {
  namespace bootstrap {

    void init_method_class()
    {
      DEF_METHOD(MethodClass,
                 "name",
                 "Returns the name of a Method as a String.",
                 name);
    }

    METHOD(MethodClass, name)
    {
      if(Method* method = dynamic_cast<Method*>(self)) {
        return String::from_value(method->name());
      } else if(NativeMethod* method = dynamic_cast<NativeMethod*>(self)) {
        return String::from_value(method->_identifier);
      } else {
        return nil;
      }
    }
  }
}
