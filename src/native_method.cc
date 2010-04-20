#include "includes.h"

namespace fancy {

  NativeMethod::NativeMethod(string identifier,
                             FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *scope),
                             unsigned int n_args,
                             bool special) : 
    FancyObject(MethodClass), _identifier(identifier), _func(func), _n_args(n_args), _special(special)
  {
  }

  NativeMethod::NativeMethod(string identifier,
                             FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *scope),
                             unsigned int n_args) :
    FancyObject(MethodClass), _identifier(identifier), _func(func), _n_args(n_args), _special(false)
  {
  }

  NativeMethod::NativeMethod(string identifier,
                             FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *scope)) :
    FancyObject(MethodClass), _identifier(identifier), _func(func), _n_args(0), _special(false)
  {
  }

  NativeMethod::~NativeMethod()
  {
  }

  FancyObject_p NativeMethod::eval(Scope *scope)
  {
    errorln("calling eval() on NativeMethod .. ");
    return nil;
  }

  FancyObject_p NativeMethod::equal(const FancyObject_p other) const
  {
    if(!IS_NATIVEMETHOD(other)) {
      return nil;
    } else {
      NativeMethod_p other_bif = (NativeMethod_p)other;
      if(this->_identifier == other_bif->_identifier) {
        return t;
      } else {
        return nil;
      }
    }
  }

  OBJ_TYPE NativeMethod::type() const
  {
    return OBJ_NATIVEMETHOD;
  }

  string NativeMethod::to_s() const
  {
    return "<NativeMethod:" + this->_identifier +">";
  }

  FancyObject_p NativeMethod::call(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
  {
    return this->_func(self, args, scope);
  }

  FancyObject_p NativeMethod::call(FancyObject_p self, Scope *scope)
  {
    return this->_func(self, list<FancyObject_p>(), scope);
  }

}
