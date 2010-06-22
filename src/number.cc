#include <sstream>

#include "number.h"
#include "bootstrap/core_classes.h"

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

  FancyObject* Number::equal(FancyObject* other) const
  {
    if(!IS_NUM(other))
      return nil;

    return (NUMVAL(this) == NUMVAL(other)) ? t : nil;
  }

  EXP_TYPE Number::type() const
  {
    if(_is_double) {
      return EXP_DOUBLE;
    } else {
      return EXP_INTEGER;
    }
  }

  string Number::to_sexp() const
  {
    if(_is_double) {
      return "[:double_lit, " + to_s() + "]";
    } else {
      return "[:int_lit, " + to_s() + "]";
    }
  }

  string Number::to_s() const
  {
    stringstream s;
    s << (is_double() ? _doubleval : _intval);
    return s.str();
  }

  bool Number::is_double() const
  {
    return _is_double;
  }

  double Number::doubleval() const
  {
    if(is_double()) {
      return _doubleval;
    } else {
      return (double)_intval;
    }
  }

  int Number::intval() const
  {
    if(is_double()) {
      return (int)_doubleval;
    } else {
      return _intval;
    }
  }

  Number** Number::int_cache;
  Number* Number::from_int(int value)
  {
    // only cache numbers up to INT_CACHE_SIZE
    if((value < 0) || (value >= INT_CACHE_SIZE)) {
      return new Number(value);
    }

    return int_cache[value];
  }

  Number* Number::from_double(double value)
  {
    return new Number(value);
  }

  void Number::init_cache()
  {
    int_cache = new Number*[INT_CACHE_SIZE];
    for(int i = 0; i < INT_CACHE_SIZE; i++) {
      int_cache[i] = new Number(i);
    }
  }

}
