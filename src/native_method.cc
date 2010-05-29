#include "native_method.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  NativeMethod::NativeMethod(string identifier,
                             FancyObject* (&func)(FancyObject* self, FancyObject* *args, int argc, Scope *scope)) :
    Method(), _identifier(identifier), _func(func)
  {
  }

  NativeMethod::NativeMethod(string identifier,
                             string docstring,
                             FancyObject* (&func)(FancyObject* self, FancyObject* *args, int argc, Scope *scope)) :
    Method(), _identifier(identifier), _func(func)
  {
    set_docstring(docstring);
  }

  NativeMethod::~NativeMethod()
  {
  }

  FancyObject* NativeMethod::equal(FancyObject* other) const
  {
    if(!IS_NATIVEMETHOD(other)) {
      return nil;
    } else {
      if(NativeMethod* other_method = dynamic_cast<NativeMethod*>(other)) {
        if(_identifier == other_method->_identifier
           && _func == other_method->_func) {
          return t;
        }
      }
      return nil;
    }
  }

  EXP_TYPE NativeMethod::type() const
  {
    return EXP_NATIVEMETHOD;
  }

  string NativeMethod::to_s() const
  {
    return "<NativeMethod:'" + _identifier + "' Doc:'" + _docstring + "'>";
  }

  FancyObject* NativeMethod::call(FancyObject* self, FancyObject* *args, int argc, Scope *scope)
  {
    return _func(self, args, argc, scope);
  }

  FancyObject* NativeMethod::call(FancyObject* self, Scope *scope)
  {
    return _func(self, 0, 0, scope);
  }

}
