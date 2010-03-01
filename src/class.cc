#include "includes.h"

Class::Class() : Module(OBJ_CLASS)
{
  this->_superclass = 0;
}

Class::Class(Class_p superclass) : 
  Module(OBJ_CLASS), _superclass(superclass)
{
}

Class::~Class()
{
}

Object_p Class::create_instance() const
{
  return nil;
}

void Class::define_slot(Identifier_p name, Object_p value)
{
  assert(name);
  assert(value);
  this->_slots[name] = value;
}

void Class::define_class_slot(Identifier_p name, Object_p value)
{
  assert(name);
  assert(value);
  this->_class_slots[name] = value;
}

void Class::include(Module_p module)
{
  assert(module);
  this->_included_modules.push_back(module);
}

map<Identifier_p, Object_p> Class::slots() const
{
  return this->_slots;
}

map<Identifier_p, Object_p> Class::class_slots() const
{
  return this->_class_slots;
}


