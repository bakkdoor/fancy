#include "includes.h"

namespace fancy {
  
  FancyException::FancyException(Class_p exception_class) :
    FancyObject(exception_class),
    _exception_value(0),
    _exception_class(exception_class)
  {
    assert(exception_class);
  }
  
  FancyException::FancyException(const string &message, Class_p exception_class) :
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

  FancyException::FancyException(FancyObject_p exception_value, const string &message) :
    FancyObject(exception_value->get_class()),
    _exception_value(exception_value),
    _exception_class(0),
    _message(message)
  {
  }

  FancyException::~FancyException()
  {
  }

  FancyObject_p FancyException::equal(const FancyObject_p other) const
  {
    FancyException_p other_except = dynamic_cast<FancyException_p>(other);
    if(!other_except)
      return nil;

    if(this->_exception_value && other_except->_exception_value) {
      return this->_exception_value->equal(other_except->_exception_value);
    }

    return nil;
  }

  OBJ_TYPE FancyException::type() const
  {
    return OBJ_EXCEPTION;
  }

  string FancyException::to_s() const
  {
    return this->exception_class()->to_s() + ": " + this->message();
  }

  string FancyException::message() const
  {
    return _message;
  }

  Class_p FancyException::exception_class() const
  {
    if(_exception_class)
      return _exception_class;

    if(_exception_value)
      return _exception_value->get_class();

    return ExceptionClass;
  }

  FancyObject_p FancyException::exception_value()
  {
    if(_exception_value)
      return _exception_value;
    return this;
  }

}
