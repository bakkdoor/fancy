#include "includes.h"

BuiltinMethod::BuiltinMethod(string identifier,
                                 Object_p (&func)(Object_p args, Scope *scope),
                                 unsigned int n_args,
                                 bool special) : 
  Object(OBJ_BIF), _identifier(identifier), _func(func), _n_args(n_args), _special(special)
{
}

BuiltinMethod::~BuiltinMethod()
{
}

Object_p BuiltinMethod::eval(Scope *scope)
{
  if(this->arg_expressions) {
    return this->_func(this->arg_expressions, scope);
  } else {
    cerr << "WARNING: no arg expressions for BIF set!" << endl;
    return nil;
  }
}

Object_p BuiltinMethod::equal(const Object_p other) const
{
  if(other->type() != OBJ_BIF) {
    return nil;
  } else {
    BuiltinMethod_p other_bif = (BuiltinMethod_p)other;
    if(this->_identifier == other_bif->_identifier) {
      return t;
    } else {
      return nil;
    }
  }
}

string BuiltinMethod::to_s() const
{
  return "<bif>";
}
