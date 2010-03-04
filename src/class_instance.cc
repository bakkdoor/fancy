#include "includes.h"

ClassInstance::ClassInstance(Class_p _class) :
  NativeObject(OBJ_CLASSINSTANCE),
  _class(_class)
{
  init_slots();
  // native_value = this;
}

ClassInstance::ClassInstance(Class_p _class, NativeObject_p native_value) :
  NativeObject(OBJ_CLASSINSTANCE),
  _class(_class),
  _native_value(native_value)
{
  init_slots();
}

ClassInstance::~ClassInstance()
{
}

Class_p ClassInstance::get_class() const
{
  return this->_class;
}

ClassInstance_p ClassInstance::get_slot(const string &slotname) const
{
  map<string, ClassInstance_p>::const_iterator it;
  it = this->slots.find(slotname);
  if(it != this->slots.end()) {
    return it->second;
  } else {
    return nil;
  }
}

ClassInstance_p ClassInstance::get_slot(const Identifier_p slotname) const
{
  assert(slotname);
  return this->get_slot(slotname->name());
}

void ClassInstance::set_slot(const string &slotname, const ClassInstance_p value)
{
  assert(value);
  this->slots[slotname] = value;
}

void ClassInstance::set_slot(const Identifier_p slotname, const ClassInstance_p value)
{
  assert(slotname);
  this->set_slot(slotname->name(), value);
}

void ClassInstance::init_slots()
{
  vector<string>::iterator it;
  for(it = this->_class->instance_slotnames().begin(); 
      it != this->_class->instance_slotnames().end();
      it++){
    this->slots[*it] = nil;
  }
}

NativeObject_p ClassInstance::equal(const NativeObject_p other) const
{
  if(!IS_CLASSINSTANCE(other))
    return nil;
  
  ClassInstance_p other_instance = dynamic_cast<ClassInstance_p>(other);

  if(this->_class->equal(other_instance->_class) != nil) {
    // TODO: compare slotvalues for both instances
    return nil;
  } else {
    return nil;
  }
}

NativeObject_p ClassInstance::eval(Scope *scope)
{
  return this;
}

string ClassInstance::to_s() const
{
  return "<ClassInstance>";
}

ClassInstance_p ClassInstance::call_method(const string &method_name, vector<Expression_p> arguments)
{
  Method_p method = this->_class->method(method_name);
  if(method) {
    // TODO: call method with args etc.
    return nil;
  } else {
    cerr << "ERROR: undefined method: " << method_name << endl;
    return nil;
  }
}

NativeObject_p ClassInstance::native_value() const
{
  return this->_native_value;
}
