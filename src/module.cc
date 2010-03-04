#include "includes.h"

Module::Module() :
  FancyObject(ModuleClass)
{
}

Module::Module(Class_p klass) :
  FancyObject(klass)
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

