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

  map<int, Number_p> Number::int_cache;
  Number_p Number::from_int(int value)
  {
    if(int_cache.find(value) != int_cache.end()) {
      return int_cache[value];
    } else {
      // insert new value into int_cache & return new number value
      Number_p new_num = new Number(value);
      int_cache[value] = new_num;
      return new_num;
    }
  }

  map<double, Number_p> Number::double_cache;
  Number_p Number::from_double(double value)
  {
    if(double_cache.find(value) != double_cache.end()) {
      return double_cache[value];
    } else {
      // insert new value into double_cache & return new number value
      Number_p new_num = new Number(value);
      double_cache[value] = new_num;
      return new_num;
    }
  }

}
