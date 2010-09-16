#include "../vendor/gc/include/gc.h"
#include "../vendor/gc/include/gc_cpp.h"
#include "../vendor/gc/include/gc_allocator.h"

#include "errors.h"
#include "array.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  FancyObject* new_method_not_found_error(const string& method_name, Class* for_class, Scope* scope)
  {
    FancyObject* err = MethodNotFoundErrorClass->create_instance();
    FancyObject* args[2] = { FancyString::from_value(method_name), for_class };
    err->send_message("initialize:for_class:", args, 2, scope, err);
    return err;
  }

  FancyObject* new_method_not_found_error(const string& method_name, Class* for_class, Scope* scope, const string& reason)
  {
    FancyObject* err = MethodNotFoundErrorClass->create_instance();
    FancyObject* args[3] = { FancyString::from_value(method_name), for_class, FancyString::from_value(reason) };
    err->send_message("initialize:for_class:reason:", args, 3, scope, err);
    return err;
  }

  FancyObject* new_division_by_zero_error(Scope* scope)
  {
    FancyObject* err = DivisionByZeroErrorClass->create_instance();
    err->send_message("initialize", &nil, 0, scope, err);
    return err;
  }

  FancyObject* new_io_error(const string &message, const string &filename, Scope* scope)
  {
    FancyObject* err = IOErrorClass->create_instance();
    FancyObject* args[2] = { FancyString::from_value(message), FancyString::from_value(filename) };
    err->send_message("initialize:filename:", args, 2, scope, err);
    return err;
  }

  FancyObject* new_io_error(const string &message, const string &filename, Array* modes, Scope* scope)
  {
    FancyObject* err = IOErrorClass->create_instance();
    FancyObject* args[3] = { FancyString::from_value(message), FancyString::from_value(filename), modes };
    err->send_message("initialize:filename:modes:", args, 3, scope, err);
    return err;
  }

  // UnknownIdentifierError

  UnknownIdentifierError::UnknownIdentifierError(const string &ident) :
    FancyException("Unknown Identifier: " + ident,
                   UnknownIdentifierErrorClass),
    _identifier(ident)
  {
  }

}
