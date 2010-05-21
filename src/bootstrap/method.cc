#include "includes.h"

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
      if(Method_p method = dynamic_cast<Method_p>(self)) {
        return String::from_value(method->name());
      } else if(NativeMethod_p method = dynamic_cast<NativeMethod_p>(self)) {
        return String::from_value(method->_identifier);
      } else {
        return nil;
      }
    }
  }
}
