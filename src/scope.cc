#include "includes.h"

void init_global_scope()
{
  global_scope = new Scope();
  global_scope->define("nil", nil);
  global_scope->define("t", t);

  // global_scope->def_builtin("define", functions::define, 2);
  // global_scope->def_builtin("car", functions::car, 1);
  // global_scope->def_builtin("cdr", functions::cdr, 1);
  // global_scope->def_builtin("cons", functions::cons, 2);
  // global_scope->def_builtin("length", functions::length, 1);
  // global_scope->def_builtin("print", functions::print_object_stdout, 1);
  // global_scope->def_builtin("println", functions::println_object_stdout, 1);
  // global_scope->def_builtin("=", functions::equal, 2);
  // global_scope->def_builtin("+", functions::add, 2);
  // global_scope->def_builtin("-", functions::subtract, 2);
  // global_scope->def_builtin("*", functions::multiply, 2);
  // global_scope->def_builtin("/", functions::divide, 2);
  // global_scope->def_builtin("%", functions::modulo, 2);
  // global_scope->def_builtin("<", functions::lt, 2);
  // global_scope->def_builtin(">", functions::gt, 2);

  // global_scope->def_builtin("if", functions::if_f, 3);
  // global_scope->def_builtin("unless", functions::unless, 3);
  // global_scope->def_builtin_special("define", functions::define, 2);
  // global_scope->def_builtin_special("lambda", functions::lambda, 2);
  // global_scope->def_builtin_special("do", functions::do_f, 2);
  // global_scope->def_builtin_special("special", functions::special, 2);
  // global_scope->def_builtin("eval", functions::eval_f, 1);

  // // global_scope->def_builtin("not", functions::not_f, 1);
  // global_scope->def_builtin_special("while", functions::while_f, 2);
}

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
                        Object_p (&func)(Object_p args, Scope *sc),
                        unsigned int n_args)
{
  BuiltinMethod_p new_builtin(new BuiltinMethod(ident,
                                                func,
                                                n_args,
                                                false));
  this->builtin_mappings[ident] = new_builtin;
}

void Scope::def_builtin(Identifier_p identifier,
                        Object_p (&func)(Object_p args, Scope *sc),
                        unsigned int n_args)
{
  BuiltinMethod_p new_builtin(new BuiltinMethod(identifier->name(),
                                                func,
                                                n_args,
                                                false));
  this->builtin_mappings[identifier->name()] = new_builtin;
}


void Scope::def_builtin_special(string ident,
                                Object_p (&func)(Object_p args, Scope *sc),
                                unsigned int n_args)
{
  BuiltinMethod_p new_builtin(new BuiltinMethod(ident,
                                                func,
                                                n_args,
                                                true));
  this->builtin_mappings[ident] = new_builtin;
}

Object_p Scope::operator[](string identifier) const
{
  map<string, Object_p>::const_iterator citer = this->value_mappings.find(identifier);
  
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

Object_p Scope::get(string identifier)
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

bool Scope::define(string identifier, Object_p value)
{
  bool found = this->value_mappings.find(identifier) != this->value_mappings.end();
  this->value_mappings[identifier] = value;
  return found;
}

string Scope::to_s() const
{
  stringstream s;

  for(map<string, Object_p>::const_iterator iter = this->value_mappings.begin();
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
