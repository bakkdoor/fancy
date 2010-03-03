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
  Class_p klass = const_cast<Class_p>(this);
  ClassInstance_p instance = new ClassInstance(klass);
  return instance;
}

void Class::define_slot(const string &name)
{
  this->_instance_slotnames.push_back(name);
}

void Class::define_slot(const Identifier_p name)
{
  assert(name);
  this->define_slot(name->name());
}

void Class::define_class_slot(const string &name, const Object_p value)
{
  assert(value);
  this->_class_slots[name] = value;
}

void Class::define_class_slot(const Identifier_p name, const Object_p value)
{
  assert(name);
  this->define_class_slot(name->name(), value);
}

void Class::include(const Module_p module)
{
  assert(module);
  this->_included_modules.push_back(module);
}

vector<string> Class::instance_slotnames() const
{
  return this->_instance_slotnames;
}

map<string, Object_p> Class::class_slots() const
{
  return this->_class_slots;
}

void Class::define_method(const string &name, const Method_p method)
{
  assert(method);
  this->_instance_methods[name] = method;
}

void Class::define_method(const Identifier_p name, const Method_p method)
{
  assert(name);
  this->define_method(name->name(), method);
}

void Class::define_class_method(const string &name, const Method_p method)
{
  assert(method);
  this->_class_methods[name] = method;
}

void Class::define_class_method(const Identifier_p name, const Method_p method)
{
  assert(name);
  this->define_class_method(name->name(), method);
}

Object_p Class::equal(const Object_p other) const
{
  if(!IS_CLASS(other))
    return nil;

  // TODO: compare slotnames, class_slots, superclass etc.
  return nil;
}

Object_p Class::eval(Scope *scope)
{
  return this;
}

string Class::to_s() const
{
  return "<Class>";
}

Method_p Class::method(const string &name)
{
  if(this->_instance_methods[name] != this->_instance_methods[name])
    return this->_instance_methods[name];
  return 0;
}
