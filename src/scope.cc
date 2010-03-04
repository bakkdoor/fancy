#include "includes.h"

Scope *global_scope;

/*****************************************
 *****************************************/

Scope::Scope()
{
  this->parent = 0;
}

Scope::Scope(Scope *parent) : parent(parent)
{
}

Scope::~Scope()
{
}


void Scope::def_builtin(string ident,
                        NativeObject_p (&func)(NativeObject_p args, Scope *sc),
                        unsigned int n_args)
{
  BuiltinMethod_p new_builtin(new BuiltinMethod(ident,
                                                func,
                                                n_args,
                                                false));
  this->builtin_mappings[ident] = new_builtin;
}

void Scope::def_builtin(Identifier_p identifier,
                        NativeObject_p (&func)(NativeObject_p args, Scope *sc),
                        unsigned int n_args)
{
  BuiltinMethod_p new_builtin(new BuiltinMethod(identifier->name(),
                                                func,
                                                n_args,
                                                false));
  this->builtin_mappings[identifier->name()] = new_builtin;
}


void Scope::def_builtin_special(string ident,
                                NativeObject_p (&func)(NativeObject_p args, Scope *sc),
                                unsigned int n_args)
{
  BuiltinMethod_p new_builtin(new BuiltinMethod(ident,
                                                func,
                                                n_args,
                                                true));
  this->builtin_mappings[ident] = new_builtin;
}

NativeObject_p Scope::operator[](string identifier) const
{
  map<string, NativeObject_p>::const_iterator citer = this->value_mappings.find(identifier);
  
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

NativeObject_p Scope::get(string identifier)
{
  if(this->value_mappings.find(identifier) != this->value_mappings.end()) {
    return this->value_mappings[identifier];
  } else {
    if(this->parent) {
      return this->parent->get(identifier);
    } else {
      // throw UnknownIdentifierError(identifier);
      return nil;
    }
  }
}

BuiltinMethod_p Scope::get_builtin(string identifier)
{
  if(this->builtin_mappings.find(identifier) != this->builtin_mappings.end()) {
    return this->builtin_mappings[identifier];
  } else {
    if(this->parent) {
      return this->parent->get_builtin(identifier);
    } else {
      // throw UnknownIdentifierError(identifier);
      return 0;
    }
  }
}

bool Scope::define(string identifier, NativeObject_p value)
{
  bool found = this->value_mappings.find(identifier) != this->value_mappings.end();
  this->value_mappings[identifier] = value;
  return found;
}

string Scope::to_s() const
{
  stringstream s;

  for(map<string, NativeObject_p>::const_iterator iter = this->value_mappings.begin();
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
