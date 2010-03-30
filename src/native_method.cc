#include "includes.h"

NativeMethod::NativeMethod(string identifier,
                           FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *scope),
                           unsigned int n_args,
                           bool special) : 
  NativeObject(), _identifier(identifier), _func(func), _n_args(n_args), _special(special)
{
}

NativeMethod::NativeMethod(string identifier,
                           FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *scope),
                           unsigned int n_args) :
  NativeObject(), _identifier(identifier), _func(func), _n_args(n_args), _special(false)
{
}

NativeMethod::NativeMethod(string identifier,
                           FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *scope)) :
  NativeObject(), _identifier(identifier), _func(func), _n_args(0), _special(false)
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

NativeObject_p NativeMethod::equal(const NativeObject_p other) const
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
