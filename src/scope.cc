#include "includes.h"

Scope *global_scope;

/*****************************************
 *****************************************/

Scope::Scope(FancyObject_p current_self) :
  parent(0),
  _current_self(current_self)
{
  assert(current_self);
  this->_current_class = current_self->get_class();
}

Scope::Scope(FancyObject_p current_self, Scope *parent) :
  parent(parent),
  _current_self(current_self)
{
  assert(current_self);
  this->_current_class = current_self->get_class();
}

Scope::~Scope()
{
}


void Scope::def_native(string ident,
                       FancyObject_p (&func)(FancyObject_p self, list<Expression_p> args, Scope *sc),
                       unsigned int n_args)
{
  NativeMethod_p new_builtin(new NativeMethod(ident,
                                              func,
                                              n_args,
                                              false));
  this->builtin_mappings[ident] = new_builtin;
}

void Scope::def_native(Identifier_p identifier,
                       FancyObject_p (&func)(FancyObject_p self, list<Expression_p> args, Scope *sc),
                       unsigned int n_args)
{
  NativeMethod_p new_builtin(new NativeMethod(identifier->name(),
                                                func,
                                                n_args,
                                                false));
  this->builtin_mappings[identifier->name()] = new_builtin;
}


void Scope::def_native_special(string ident,
                               FancyObject_p (&func)(FancyObject_p self, list<Expression_p> args, Scope *sc),
                               unsigned int n_args)
{
  NativeMethod_p new_builtin(new NativeMethod(ident,
                                              func,
                                              n_args,
                                              true));
  this->builtin_mappings[ident] = new_builtin;
}

FancyObject_p Scope::operator[](string identifier) const
{
  map<string, FancyObject_p>::const_iterator citer = this->value_mappings.find(identifier);
  
  if (citer == this->value_mappings.end()) {
    if(this->parent) {
      return (*this->parent)[identifier];
    } else {
      // throw UnknownIdentifierError(identifier);
      return nil;
    }
  }
  
  return (*citer).second;
}

FancyObject_p Scope::get(string identifier)
{
  if(this->value_mappings.find(identifier) != this->value_mappings.end()) {
    return this->value_mappings[identifier];
  } else {
    // try to look in current_self & current_class
    // current_self
    if(this->parent) {
      return this->parent->get(identifier);
    } else {
      // throw UnknownIdentifierError(identifier);
      return nil;
    }
  }
}

NativeMethod_p Scope::get_native(string identifier)
{
  if(this->builtin_mappings.find(identifier) != this->builtin_mappings.end()) {
    return this->builtin_mappings[identifier];
  } else {
    if(this->parent) {
      return this->parent->get_native(identifier);
    } else {
      // throw UnknownIdentifierError(identifier);
      return 0;
    }
  }
}

bool Scope::define(string identifier, FancyObject_p value)
{
  bool found = this->value_mappings.find(identifier) != this->value_mappings.end();
  this->value_mappings[identifier] = value;
  return found;
}

string Scope::to_s() const
{
  stringstream s;

  for(map<string, FancyObject_p>::const_iterator iter = this->value_mappings.begin();
      iter != this->value_mappings.end();
      iter++) {
    s << iter->first;
    s << ": ";
    s << iter->second->to_s();
    s << endl;
  }

  return s.str();
}

int Scope::size() const
{
  return this->value_mappings.size() + this->builtin_mappings.size();
}

FancyObject_p Scope::current_self() const
{
  return this->_current_self;
}

Class* Scope::current_class() const
{
 return this->_current_class;
}
