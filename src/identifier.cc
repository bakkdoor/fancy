#include "includes.h"

Identifier::Identifier(const string &name) : Object(OBJ_IDENTIFIER), _name(name)
{
}

Identifier::~Identifier()
{
}

Object_p Identifier::equal(const Object_p other) const
{
  if(!IS_IDENT(other))
    return nil;
  
  Identifier_p other_ident = (Identifier_p)other;
  if(this->_name == other_ident->_name)
    return t;
  return nil;
}

Object_p Identifier::eval(Scope *scope)
{
  BuiltinMethod_p bif = scope->get_builtin(this->_name);
  if(bif) {
    return bif;
  } else {
     return scope->get(this->_name);
  }
}

string Identifier::to_s() const
{
  return this->_name;
}

string Identifier::name() const
{
  return this->_name;
}

map<string, Identifier_p> Identifier::ident_cache;
Identifier_p Identifier::from_string(const string &name)
{
  if(ident_cache.find(name) != ident_cache.end()) {
    return ident_cache[name];
  } else {
    // insert new name into ident_cache & return new number name
    Identifier_p new_ident = new Identifier(name);
    ident_cache[name] = new_ident;
    return new_ident;
  }
}
