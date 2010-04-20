#include "includes.h"

namespace fancy {

  FancyObject::FancyObject(Class_p _class) :
    _class(_class)
  {
    init_slots();
  }

  FancyObject::~FancyObject()
  {
  }

  Class_p FancyObject::get_class() const
  {
    return this->_class;
  }

  void FancyObject::set_class(Class_p klass)
  {
    if(klass) {
      this->_class = klass;
      init_slots();
    }
  }

  FancyObject_p FancyObject::get_slot(const string &slotname) const
  {
    object_map::const_iterator it = this->slots.find(slotname);
    if(it != this->slots.end()) {
      return it->second;
    } else {
      return nil;
    }
  }

  FancyObject_p FancyObject::get_slot(const Identifier_p slotname) const
  {
    assert(slotname);
    return this->get_slot(slotname->name());
  }

  void FancyObject::set_slot(const string &slotname, const FancyObject_p value)
  {
    assert(value);
    this->slots[slotname] = value;
  }

  void FancyObject::set_slot(const Identifier_p slotname, const FancyObject_p value)
  {
    assert(slotname);
    this->set_slot(slotname->name(), value);
  }

  void FancyObject::init_slots()
  {
    if(this->_class) {
      vector<string>::iterator it;
      for(it = this->_class->instance_slotnames().begin(); 
          it != this->_class->instance_slotnames().end();
          it++){
        this->slots[*it] = nil;
      }
    }
  }

  FancyObject_p FancyObject::equal(const FancyObject_p other) const
  {
    if(!IS_CLASSINSTANCE(other))
      return nil;
  
    FancyObject_p other_instance = dynamic_cast<FancyObject_p>(other);

    if(this->_class->equal(other_instance->_class) != nil) {
      // TODO: compare slotvalues for both instances
      return nil;
    } else {
      return nil;
    }
  }

  FancyObject_p FancyObject::eval(Scope *scope)
  {
    return this;
  }

  OBJ_TYPE FancyObject::type() const
  {
    return OBJ_CLASSINSTANCE;
  }

  string FancyObject::to_s() const
  {
    return "<Unkown FancyObject>";
  }

  string FancyObject::inspect() const
  {
    return this->to_s();
  }

  FancyObject_p FancyObject::call_method(const string &method_name, list<FancyObject_p> arguments, Scope *scope)
  {
    Callable_p method = this->get_method(method_name);
    if(method) {
      return method->call(this, arguments, scope);
    } else {
      // handle unkown messages, if unkown_message:with_params is defined
      if(Callable_p unkown_message_method = this->get_method("unknown_message:with_params:")) {
        list<FancyObject_p> new_args;
        new_args.push_back(String::from_value(method_name));
        new_args.push_back(new Array(vector<FancyObject_p>(arguments.begin(), arguments.end())));
        return unkown_message_method->call(this, new_args, scope);
      }
      
      // in this case no method is found and we raise a MethodNotFoundError
      FancyException_p except = new MethodNotFoundError(method_name, this->_class);
      throw except;
      return nil;
    }
  }

  void FancyObject::def_singleton_method(const string &name, Callable_p method)
  {
    assert(method);
    this->_singleton_methods[name] = method;
  }

  bool FancyObject::responds_to(const string &method_name)
  {
    if(this->get_method(method_name)) {
      return true;
    } else {
      return false;
    }
  }

  Callable_p FancyObject::get_method(const string &method_name)
  {
    // first of all, check singleton methods
    method_map::const_iterator it = this->_singleton_methods.find(method_name);
    if(it != this->_singleton_methods.end()) {
      return it->second;
    } else {
      return this->_class->find_method(method_name);
    }
  }

  string FancyObject::docstring() const
  {
    return _docstring;
  }

  void FancyObject::set_docstring(const string &docstring)
  {
    _docstring = docstring;
  }
}
