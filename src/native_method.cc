#include "includes.h"

NativeMethod::NativeMethod(string identifier,
                           FancyObject_p (&func)(FancyObject_p args, Scope *scope),
                           unsigned int n_args,
                           bool special) : 
  NativeObject(OBJ_BIF), _identifier(identifier), _func(func), _n_args(n_args), _special(special)
{
}

NativeMethod::~NativeMethod()
{
}

FancyObject_p NativeMethod::eval(Scope *scope)
{
  if(this->arg_expressions) {
    // return this->_func(this->arg_expressions, scope);
    return nil;
  } else {
    cerr << "WARNING: no arg expressions for BIF set!" << endl;
    return nil;
  }
}

NativeObject_p NativeMethod::equal(const NativeObject_p other) const
{
  if(other->type() != OBJ_BIF) {
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

string NativeMethod::to_s() const
{
  return "<bif>";
}
