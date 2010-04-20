#include "includes.h"

namespace fancy {

  Number::Number(double value) :
    FancyObject(NumberClass), _intval(0), _doubleval(value), _is_double(true)
  {
  }

  Number::Number(int value) :
    FancyObject(NumberClass), _intval(value), _doubleval(0), _is_double(false)
  {
  }

  Number::~Number()
  {
  }

  FancyObject_p Number::equal(const FancyObject_p other) const
  {
    if(!IS_NUM(other))
      return nil;

    return (NUMVAL(this) == NUMVAL(other)) ? t : nil;
  }

  OBJ_TYPE Number::type() const
  {
    if(_is_double) {
      return OBJ_DOUBLE;
    } else {
      return OBJ_INTEGER;
    }
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

  Number_p* Number::int_cache;
  Number_p Number::from_int(int value)
  {
    // only cache numbers up to INT_CACHE_SIZE
    if((value < 0) || (value >= INT_CACHE_SIZE)) {
      return new Number(value);
    }

    return int_cache[value];
  }

  Number_p Number::from_double(double value)
  {
    return new Number(value);
  }

  void Number::init_cache()
  {
    int_cache = new Number_p[INT_CACHE_SIZE];
    for(int i = 0; i < INT_CACHE_SIZE; i++) {
      int_cache[i] = new Number(i);
    }
  }

}
