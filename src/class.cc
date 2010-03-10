#include "includes.h"

Class::Class() : Module(ClassClass)
{
  this->_superclass = 0;
}

Class::Class(Class_p superclass) : 
  Module(ClassClass), _superclass(superclass)
{
}

Class::~Class()
{
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

void Class::define_slot(const string &name)
{
  this->_instance_slotnames.push_back(name);
}

void Class::define_slot(const Identifier_p name)
{
  assert(name);
  this->define_slot(name->name());
}

void Class::define_class_slot(const string &name, const NativeObject_p value)
{
  assert(value);
  this->_class_slots[name] = value;
}

void Class::define_class_slot(const Identifier_p name, const NativeObject_p value)
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

map<string, NativeObject_p> Class::class_slots() const
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
  // class methods are nothing else than singleton methods on class objects :)
  this->define_singleton_method(name, method);
}

void Class::define_class_method(const Identifier_p name, const Method_p method)
{
  assert(name);
  this->define_singleton_method(name->name(), method);
}

void Class::define_native_class_method(const NativeMethod_p method)
{
  assert(method);
  // same here, see above
  this->define_native_singleton_method(method);
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

string Class::to_s() const
{
  return "<Class>";
}

Method_p Class::find_method(const string &name)
{
  // first, try instance methods
  if(this->_instance_methods.find(name) != this->_instance_methods.end()) {
    return this->_instance_methods[name];
  }

  return 0;
}

NativeMethod_p Class::find_native_method(const string &name)
{
  // first, try native instance methods
  if(this->_native_instance_methods.find(name) != this->_native_instance_methods.end()) {
    return this->_native_instance_methods[name];
  }

  return 0;
}
