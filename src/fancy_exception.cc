#include <cassert>

#include "fancy_exception.h"
#include "bootstrap/core_classes.h"

namespace fancy {
  
  FancyException::FancyException(Class* exception_class) :
    FancyObject(exception_class),
    _exception_value(0),
    _exception_class(exception_class)
  {
    assert(exception_class);
  }
  
  FancyException::FancyException(const string &message, Class* exception_class) :
    FancyObject(exception_class),
    _exception_value(0),
    _exception_class(exception_class),
    _message(message)
  {
    assert(exception_class);
  }

  FancyException::FancyException(const string &message) :
    FancyObject(ExceptionClass),
    _exception_value(0),
    _exception_class(0),
    _message(message)
  {
  }

  FancyException::FancyException(FancyObject* exception_value, const string &message) :
    FancyObject(exception_value->get_class()),
    _exception_value(exception_value),
    _exception_class(0),
    _message(message)
  {
  }

  FancyException::~FancyException()
  {
  }

  EXP_TYPE FancyException::type() const
  {
    return EXP_EXCEPTION;
  }

  string FancyException::to_s() const
  {
    return exception_class()->to_s() + ": " + message();
  }

  string FancyException::message() const
  {
    return _message;
  }

  Class* FancyException::exception_class() const
  {
    if(_exception_class)
      return _exception_class;

    if(_exception_value)
      return _exception_value->get_class();

    return ExceptionClass;
  }

  FancyObject* FancyException::exception_value()
  {
    if(_exception_value)
      return _exception_value;
    return this;
  }

}
