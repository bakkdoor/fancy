#include "includes.h"

Class::Class(const string &name) :
  Module(ClassClass),
  _name(name)
{
  this->_superclass = 0;
}

Class::Class(const string &name, Class_p superclass) : 
  Module(ClassClass),
  _name(name),
  _superclass(superclass)
{
}

Class::~Class()
{
}

string Class::name() const
{
  return _name;
}

FancyObject_p Class::create_instance() const
{
  Class_p klass = const_cast<Class_p>(this);
  FancyObject_p instance = new FancyObject(klass);
  return instance;
}

FancyObject_p Class::create_instance(NativeObject_p native_value) const
{
  Class_p klass = const_cast<Class_p>(this);
  FancyObject_p instance = new FancyObject(klass, native_value);
  return instance;
}

void Class::def_slot(const string &name)
{
  this->_instance_slotnames.push_back(name);
}

void Class::def_slot(const Identifier_p name)
{
  assert(name);
  this->def_slot(name->name());
}

void Class::def_class_slot(const string &name, const FancyObject_p value)
{
  assert(value);
  this->_class_slots[name] = value;
}

void Class::def_class_slot(const Identifier_p name, const FancyObject_p value)
{
  assert(name);
  this->def_class_slot(name->name(), value);
}

FancyObject_p Class::get_class_slot(const string &identifier) const
{
  map<string, FancyObject_p>::const_iterator it;
  it = this->slots.find(identifier);
  if(it != this->slots.end()) {
    return it->second;
  } else {
    return nil;
  }
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

map<string, FancyObject_p> Class::class_slots() const
{
  return this->_class_slots;
}

void Class::def_method(const string &name, const Callable_p method)
{
  assert(method);
  this->_instance_methods[name] = method;
}

void Class::def_method(const Identifier_p name, const Callable_p method)
{
  assert(name);
  this->def_method(name->name(), method);
}

void Class::def_class_method(const string &name, const Callable_p method)
{
  assert(method);
  // class methods are nothing else than singleton methods on class objects :)
  this->def_singleton_method(name, method);
}

void Class::def_class_method(const Identifier_p name, const Callable_p method)
{
  assert(name);
  this->def_singleton_method(name->name(), method);
}

NativeObject_p Class::equal(const NativeObject_p other) const
{
  if(!IS_CLASS(other))
    return nil;

  // TODO: compare slotnames, class_slots, superclass etc.
  return nil;
}

FancyObject_p Class::eval(Scope *scope)
{
  return this;
}

OBJ_TYPE Class::type() const
{
  return OBJ_CLASS;
}

string Class::to_s() const
{
  return "<Class:" + this->_name + ">";
}

Callable_p Class::find_method(const string &name)
{
  // first, try instance methods
  if(this->_instance_methods.find(name) != this->_instance_methods.end()) {
    return this->_instance_methods[name];
  }
  // then, try singleton methods (class methods)
  if(this->_singleton_methods.find(name) != this->_singleton_methods.end()) {
    return this->_singleton_methods[name];
  }
  // then, try getting method from superclass (if there is any)
  if(this->_superclass) {
    return this->_superclass->find_method(name);
  }

  return 0;
}
