#include "includes.h"

namespace fancy {

  NativeMethod::NativeMethod(string identifier,
                             FancyObject_p (&func)(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)) :
    Method(), _identifier(identifier), _func(func)
  {
  }

  NativeMethod::NativeMethod(string identifier,
                             string docstring,
                             FancyObject_p (&func)(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)) :
    Method(), _identifier(identifier), _func(func)
  {
    set_docstring(docstring);
  }

  NativeMethod::~NativeMethod()
  {
  }

  FancyObject_p NativeMethod::equal(const FancyObject_p other) const
  {
    if(!IS_NATIVEMETHOD(other)) {
      return nil;
    } else {
      if(NativeMethod_p other_method = dynamic_cast<NativeMethod_p>(other)) {
        if(_identifier == other_method->_identifier
           && _func == other_method->_func) {
          return t;
        }
      }
      return nil;
    }
  }

  OBJ_TYPE NativeMethod::type() const
  {
    return OBJ_NATIVEMETHOD;
  }

  string NativeMethod::to_s() const
  {
    return "<NativeMethod:'" + _identifier + "' Doc:'" + _docstring + "'>";
  }

  FancyObject_p NativeMethod::call(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
  {
    return _func(self, args, argc, scope);
  }

  FancyObject_p NativeMethod::call(FancyObject_p self, Scope *scope)
  {
    return _func(self, 0, 0, scope);
  }

}
