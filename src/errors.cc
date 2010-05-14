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
    FancyException("Method not found: '" + method_name + "' for class: " + klass->name(),
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

  // IOError

  IOError::IOError(const string &message, const string &filename) :
    FancyException(message + filename,
                   IOErrorClass),
    _filename(filename)
  {
  }

  IOError::IOError(const string &message, const string &filename, Array_p modes) :
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

  Array_p IOError::modes() const
  {
    return _modes;
  }

}
