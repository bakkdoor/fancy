#include "includes.h"

Object::Object(OBJ_TYPE type) : obj_type(type), quoted(false)
{
}

Object::Object(OBJ_TYPE type, bool quoted) : obj_type(type), quoted(quoted)
{
}

Object::~Object()
{
}

OBJ_TYPE Object::type() const
{
  return this->obj_type;
}

unsigned int Object::object_id() const
{
  return this->obj_id;
}

string Object::to_s() const
{
  stringstream s;
  s << "[unkown object (" << this->type() << ")]";
  return s.str();
}

bool Object::is_quoted() const
{
  return this->quoted;
}

void Object::set_quoted(bool quoted)
{
  this->quoted = quoted;
}

Object_p Object::set_slot(string name, Object_p value)
{
  this->_slot_values[name] = value;
  return value;
}

Object_p Object::get_slot(string name) const
{
  map<string, Object_p>::const_iterator citer = this->_slot_values.find(name);
  if (citer == this->_slot_values.end()) {
    return nil;
  }

  if(citer->second)
    return citer->second;

  return nil;
}

Hash_p Object::slot_values() const
{
  map<Object_p, Object_p> slot_map;
  map<string, Object_p>::const_iterator it;
  for(it = this->_slot_values.begin(); it != this->_slot_values.end(); it++) {
    if(it->second) {
      Identifier_p slot_name = new Identifier(it->first);
      slot_map[slot_name] = it->second;
    }
  }
  return new Hash(slot_map);
}
