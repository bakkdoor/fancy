#include "includes.h"

namespace fancy {

  // UnknownIdentifierError

  UnknownIdentifierError::UnknownIdentifierError(const string &ident) :
    FancyException("Unknown Identifier: " + ident),
    _identifier(ident) {}

  UnknownIdentifierError::~UnknownIdentifierError() {}

  string UnknownIdentifierError::identifier() const
  {
    return this->_identifier;
  }

  // NoMethodError

  MethodNotFoundError::MethodNotFoundError(const string &method_name, Class_p klass) :
    FancyException("Method not found: " + method_name + " for class: " + klass->name(),
                   MethodNotFoundErrorClass),
    _method_name(method_name),
    _class(klass)
  {
  }

  MethodNotFoundError::~MethodNotFoundError()
  {
  }
  
  string MethodNotFoundError::method_name() const
  {
    return _method_name;
  }

  Class_p MethodNotFoundError::get_class() const
  {
    return _class;
  }

}
