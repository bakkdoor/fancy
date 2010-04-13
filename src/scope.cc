#include "includes.h"

namespace fancy {

  Scope *global_scope;

  /*****************************************
   *****************************************/

  Scope::Scope(FancyObject_p current_self) :
    FancyObject(ScopeClass),
    parent(0)
  {
    assert(current_self);
    set_current_self(current_self);
  }

  Scope::Scope(FancyObject_p current_self, Scope *parent) :
    FancyObject(ScopeClass),
    parent(parent)
  {
    assert(current_self);
    set_current_self(current_self);
  }

  Scope::~Scope()
  {
  }


  void Scope::def_native(string ident,
                         FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *sc),
                         unsigned int n_args)
  {
    NativeMethod_p new_builtin(new NativeMethod(ident,
                                                func,
                                                n_args,
                                                false));
    this->builtin_mappings[ident] = new_builtin;
  }

  void Scope::def_native(Identifier_p identifier,
                         FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *sc),
                         unsigned int n_args)
  {
    NativeMethod_p new_builtin(new NativeMethod(identifier->name(),
                                                func,
                                                n_args,
                                                false));
    this->builtin_mappings[identifier->name()] = new_builtin;
  }


  void Scope::def_native_special(string ident,
                                 FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *sc),
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
    // check for current_scope
    if(identifier == "__current_scope__")
      return this;

    // check for instance & class variables
    if(identifier[0] == '@') {
      if(identifier[1] == '@') {
        if(IS_CLASS(this->_current_self)) {
          return dynamic_cast<Class_p>(this->_current_self)->get_class_slot(identifier);
        } else {
          return this->_current_class->get_class_slot(identifier);
        }
      } else {
        return this->_current_self->get_slot(identifier);
      }
    }

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
    // check for instance & class variables
    if(identifier[0] == '@') {
      if(identifier[1] == '@') {
        if(IS_CLASS(this->_current_self)) {
          dynamic_cast<Class_p>(this->_current_self)->def_class_slot(identifier, value);
        } else {
          this->_current_class->def_class_slot(identifier, value);
        }
        return true;
      } else {
        this->_current_self->set_slot(identifier, value);
        return true;
      }
    }

    bool found = this->value_mappings.find(identifier) != this->value_mappings.end();
    this->value_mappings[identifier] = value;
    return found;
  }

  FancyObject_p Scope::equal(const FancyObject_p other) const
  {
    return nil;
  }

  OBJ_TYPE Scope::type() const
  {
    return OBJ_SCOPE;
  }

  string Scope::to_s() const
  {
    stringstream s;
    s << "Scope:" << endl;

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

  void Scope::set_current_self(FancyObject_p current_self)
  {
    this->_current_self = current_self;
    this->_current_class = current_self->get_class();
    this->define("self", current_self);
  }

  void Scope::set_current_class(Class_p klass)
  {
    if(klass)
      this->_current_class = klass;
  }

  Scope* Scope::parent_scope() const
  {
    return parent;
  }

}
