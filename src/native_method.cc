#include "../vendor/gc/include/gc.h"
#include "../vendor/gc/include/gc_cpp.h"
#include "../vendor/gc/include/gc_allocator.h"

#include "native_method.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  NativeMethod::NativeMethod(string identifier,
                             FancyObject* (&func)(FancyObject* self, FancyObject* *args, int argc, Scope *scope, FancyObject* sender)) :
    Method(), _identifier(identifier), _func(func)
  {
  }

  NativeMethod::NativeMethod(string identifier,
                             string docstring,
                             FancyObject* (&func)(FancyObject* self, FancyObject* *args, int argc, Scope *scope, FancyObject* sender)) :
    Method(), _identifier(identifier), _func(func)
  {
    set_docstring(docstring);
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

  string NativeMethod::to_s() const
  {
    return "<NativeMethod:'" + _identifier + "' Doc:'" + _docstring + "'>";
  }

  FancyObject* NativeMethod::call(FancyObject* self, FancyObject* *args, int argc, Scope *scope, FancyObject* sender)
  {
    Callable::check_sender_access(_identifier, self, sender);
    return _func(self, args, argc, scope, sender);
  }

  FancyObject* NativeMethod::call(FancyObject* self, Scope *scope, FancyObject* sender)
  {
    Callable::check_sender_access(_identifier, self, sender);
    return _func(self, 0, 0, scope, sender);
  }

}
