#include "includes.h"

namespace fancy {

  Scope *global_scope;

  /*****************************************
   *****************************************/

  Scope::Scope(FancyObject_p current_self) :
    FancyObject(ScopeClass),
    _parent(0)
  {
    assert(current_self);
    set_current_self(current_self);
  }

  Scope::Scope(Scope *parent) :
    FancyObject(ScopeClass),
    _parent(parent)
  {
    if(parent) {
      assert(parent->_current_self);
      set_current_self(parent->_current_self);
    }
  }

  Scope::Scope(FancyObject_p current_self, Scope *parent) :
    FancyObject(ScopeClass),
    _parent(parent)
  {
    assert(current_self);
    set_current_self(current_self);
  }

  Scope::~Scope()
  {
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

    object_map::const_iterator it = this->_value_mappings.find(identifier);
    if(it != this->_value_mappings.end()) {
      return it->second;
    } else {
      // try to look in current_self & current_class
      // current_self
      if(this->_parent) {
        return this->_parent->get(identifier);
      } else {
        // throw UnknownIdentifierError(identifier);
        return nil;
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

    bool found = this->_value_mappings.find(identifier) != this->_value_mappings.end();
    this->_value_mappings[identifier] = value;
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

    for(map<string, FancyObject_p>::const_iterator iter = this->_value_mappings.begin();
        iter != this->_value_mappings.end();
        iter++) {
      s << iter->first;
      s << ": ";
      s << iter->second->to_s();
      s << endl;
    }

    return s.str();
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
    return _parent;
  }

}
