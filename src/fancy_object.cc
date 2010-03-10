#include "includes.h"

FancyObject::FancyObject(Class_p _class) :
  NativeObject(OBJ_CLASSINSTANCE),
  _class(_class),
  _native_value(0)
{
  init_slots();
  // native_value = this;
}

FancyObject::FancyObject(Class_p _class, NativeObject_p native_value) :
  NativeObject(OBJ_CLASSINSTANCE),
  _class(_class),
  _native_value(native_value)
{
  init_slots();
}

FancyObject::~FancyObject()
{
}

Class_p FancyObject::get_class() const
{
  return this->_class;
}

void FancyObject::set_class(Class_p klass)
{
  if(klass) {
    this->_class = klass;
    init_slots();
  }
}

FancyObject_p FancyObject::get_slot(const string &slotname) const
{
  map<string, FancyObject_p>::const_iterator it;
  it = this->slots.find(slotname);
  if(it != this->slots.end()) {
    return it->second;
  } else {
    return nil;
  }
}

FancyObject_p FancyObject::get_slot(const Identifier_p slotname) const
{
  assert(slotname);
  return this->get_slot(slotname->name());
}

void FancyObject::set_slot(const string &slotname, const FancyObject_p value)
{
  assert(value);
  this->slots[slotname] = value;
}

void FancyObject::set_slot(const Identifier_p slotname, const FancyObject_p value)
{
  assert(slotname);
  this->set_slot(slotname->name(), value);
}

void FancyObject::init_slots()
{
  if(this->_class) {
    vector<string>::iterator it;
    for(it = this->_class->instance_slotnames().begin(); 
        it != this->_class->instance_slotnames().end();
        it++){
      this->slots[*it] = nil;
    }
  }
}

NativeObject_p FancyObject::equal(const NativeObject_p other) const
{
  if(!IS_CLASSINSTANCE(other))
    return nil;
  
  FancyObject_p other_instance = dynamic_cast<FancyObject_p>(other);

  if(this->_class->equal(other_instance->_class) != nil) {
    // TODO: compare slotvalues for both instances
    return nil;
  } else {
    return nil;
  }
}

FancyObject_p FancyObject::eval(Scope *scope)
{
  return this;
}

string FancyObject::to_s() const
{
  if(this->_native_value) {
    return this->_native_value->to_s();
  } else {
    return "<FancyObject>";
  }
}

FancyObject_p FancyObject::call_method(const string &method_name, list<Expression_p> arguments, Scope *scope)
{
  // first of all, check singleton methods
  if(this->_native_singleton_methods.find(method_name) != this->_native_singleton_methods.end()) {
    NativeMethod_p native_singleton = this->_native_singleton_methods[method_name];
    return native_singleton->call(arguments, scope);
  }

  // check native methods first.
  // then check user-defined methods
  NativeMethod_p native_method = this->_class->find_native_method(method_name);
  if(native_method) {
    return native_method->call(arguments, scope);
  }

  Method_p method = this->_class->find_method(method_name);
  cout << "calling method: " << method_name << endl;
  if(method) {
    // TODO: call method with args etc.
    return nil;
  } else {
    cerr << "ERROR: undefined method: " << method_name << endl;
    return nil;
  }
}

NativeObject_p FancyObject::native_value() const
{
  return this->_native_value;
}

void FancyObject::define_singleton_method(const string &name, Method_p method)
{
  assert(method);
  this->_singleton_methods[name] = method;
}

void FancyObject::define_native_singleton_method(const NativeMethod_p method)
{
  assert(method);
  this->_native_singleton_methods[method->_identifier] = method;
}
