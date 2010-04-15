#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_method_class()
    {
      MethodClass->def_method("docstring", new NativeMethod("docstring", method_Method_docstring));
    }

    /**
     * Method instance methods
     */
    FancyObject_p method_Method_docstring(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      if(Method_p method = dynamic_cast<Method_p>(self)) {
        return String::from_value(method->docstring());
      }
    }

  }
}
