#include "includes.h"

Number::Number(double value) :
  Object(OBJ_DOUBLE), _intval(0), _doubleval(value), _is_double(true)
{
}

Number::Number(int value) :
  Object(OBJ_INTEGER), _intval(value), _doubleval(0), _is_double(false)
{
}

Number::~Number()
{
}

Object_p Number::equal(const Object_p other) const
{
  if(!IS_NUM(other))
    return nil;

  return (NUMVAL(this) == NUMVAL(other)) ? t : nil;
}
  
Object_p Number::eval(Scope *scope)
{
  return this;
}

string Number::to_s() const
{
  stringstream s;
  s << (this->is_double() ? this->_doubleval : this->_intval);
  return s.str();
}

bool Number::is_double() const
{
  return this->_is_double;
}

double Number::doubleval() const
{
  if(is_double()) {
    return this->_doubleval;
  } else {
    return (double)this->_intval;
  }
}

int Number::intval() const
{
  if(this->is_double()) {
    return (int)this->_doubleval;
  } else {
    return this->_intval;
  }
}
