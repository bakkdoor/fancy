#include <cassert>
#include <sstream>
#include <string>

#include "scope.h"
#include "class.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  Scope *global_scope;

  /*****************************************
   *****************************************/

  Scope::Scope() :
    _parent(NULL),
    _current_self(nil),
    _current_class(NilClass),
    _closed(false),
    _current_sender(nil)
  {
  }

  Scope::Scope(FancyObject* current_self) :
    _parent(NULL),
    _closed(false),
    _current_sender(nil)
  {
    assert(current_self);
    set_current_self(current_self);
  }

  Scope::Scope(Scope *parent) :
    _parent(parent),
    _closed(false),
    _current_sender(nil)
  {
    if(parent) {
      assert(parent->_current_self);
      set_current_self(parent->_current_self);
      if(parent->_current_sender) {
        _current_sender = parent->_current_sender;
      }
    }
  }

  Scope::Scope(FancyObject* current_self, Scope *parent) :
    _parent(parent),
    _closed(false),
    _current_sender(nil)
  {
    assert(current_self);
    set_current_self(current_self);
    if(parent && parent->_current_sender) {
      _current_sender = parent->_current_sender;
    }
  }

  Scope::~Scope()
  {
  }

  FancyObject* Scope::get(string identifier)
  {
    // check for instance & class variables
    if(identifier[0] == '@') {
      if(identifier[1] == '@') {
        if(IS_CLASS(_current_self)) {
          return dynamic_cast<Class*>(_current_self)->get_class_slot(identifier);
        } else {
          return _current_class->get_class_slot(identifier);
        }
      } else {
        return _current_self->get_slot(identifier);
      }
    }

    if(identifier == "self") {
      return _current_self;
    }

    if(identifier == "__sender__") {
      return _current_sender;
    }

    object_map::const_iterator it = _value_mappings.find(identifier);
    if(it != _value_mappings.end()) {
      return it->second;
    } else {
      // try to look in current_self & current_class
      // current_self
      if(_parent) {
        return _parent->get(identifier);
      } else {
        // throw UnknownIdentifierError(identifier);
        return nil;
      }
    }
  }

  bool Scope::define(string identifier, FancyObject* value)
  {
    // check for instance & class variables
    if(identifier[0] == '@') {
      if(identifier[1] == '@') {
        if(IS_CLASS(_current_self)) {
          dynamic_cast<Class*>(_current_self)->def_class_slot(identifier, value);
        } else {
          _current_class->def_class_slot(identifier, value);
        }
        return true;
      } else {
        _current_self->set_slot(identifier, value);
        return true;
      }
    }

    bool found = _value_mappings.find(identifier) != _value_mappings.end();
    _value_mappings[identifier] = value;
    return found;
  }

  FancyObject* Scope::current_self() const
  {
    return _current_self;
  }

  Class* Scope::current_class() const
  {
    return _current_class;
  }

  void Scope::set_current_self(FancyObject* current_self)
  {
    _current_self = current_self;
    _current_class = current_self->get_class();
  }

  void Scope::set_current_class(Class* klass)
  {
    if(klass)
      _current_class = klass;
  }

  Scope* Scope::parent_scope() const
  {
    return _parent;
  }

  map<string, FancyObject*> Scope::value_mappings() const
  {
    return _value_mappings;
  }
}
