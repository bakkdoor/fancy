#include "includes.h"

Module::Module() :
  Object(OBJ_MODULE)
{
}

Module::Module(OBJ_TYPE type) : Object(type)
{
}

Module::~Module()
{
}

map<Identifier_p, Method_p> Module::methods() const
{
  return this->_methods;
}

map<Identifier_p, Method_p> Module::class_methods() const
{
  return this->_class_methods;
}

void Module::define_method(Identifier_p name, Method_p method)
{
  assert(name);
  assert(method);
  this->_methods[name] = method;
}

void Module::define_class_method(Identifier_p name, Method_p method)
{
  assert(name);
  assert(method);
  this->_class_methods[name] = method;  
}

