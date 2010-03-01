#include "includes.h"

String::String(const string &value) : Object(OBJ_STRING), _value(value)
{
}

String::~String()
{
}

Object_p String::equal(const Object_p other) const
{
  if(!IS_STRING(other))
    return nil;

  String_p other_string = (String_p)other;
  if(this->_value == other_string->_value)
    return t;
  return nil;
}

Object_p String::eval(Scope *scope)
{
  return this;
}

string String::to_s() const
{
  return "\"" + this->_value + "\"";
}

string String::value() const
{
  return this->_value;
}

map<string, String_p> String::value_cache;
String_p String::from_value(const string &value)
{
  if(value_cache.find(value) != value_cache.end()) {
    return value_cache[value];
  } else {
    // insert new value into value_cache & return new number value
    String_p new_string = new String(value);
    value_cache[value] = new_string;
    return new_string;
  }
}
