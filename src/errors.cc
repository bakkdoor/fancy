#include "errors.h"
#include "array.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  // UnknownIdentifierError

  UnknownIdentifierError::UnknownIdentifierError(const string &ident) :
    FancyException("Unknown Identifier: " + ident),
    _identifier(ident) {}

  UnknownIdentifierError::~UnknownIdentifierError() {}

  string UnknownIdentifierError::identifier() const
  {
    return _identifier;
  }

  // NoMethodError

  MethodNotFoundError::MethodNotFoundError(const string &method_name, Class* klass) :
    FancyException("Method not found: '" + method_name + "' for class: " + klass->name(),
                   MethodNotFoundErrorClass),
    _method_name(method_name),
    _class(klass)
  {
  }

  MethodNotFoundError::MethodNotFoundError(const string &method_name, Class* klass, const string &reason) :
    FancyException("Method not found: '" + method_name + "' for class: " + klass->name() + " (" + reason + ")",
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

  Class* MethodNotFoundError::get_class() const
  {
    return _class;
  }

  // IOError

  IOError::IOError(const string &message, const string &filename) :
    FancyException(message + filename,
                   IOErrorClass),
    _filename(filename)
  {
  }

  IOError::IOError(const string &message, const string &filename, Array* modes) :
    FancyException(message + "\"" + filename + "\"" + " with modes: " + modes->inspect(),
                   IOErrorClass),
    _filename(filename),
    _modes(modes)
  {
  }

  IOError::~IOError()
  {
  }
  
  string IOError::filename() const
  {
    return _filename;
  }

  Array* IOError::modes() const
  {
    return _modes;
  }

  // DivisionByZeroError

  DivisionByZeroError::DivisionByZeroError() :
    FancyException("Division by zero!", DivisionByZeroErrorClass)
  {
  }

  DivisionByZeroError::~DivisionByZeroError()
  {
  }

}
