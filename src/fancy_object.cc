#include <cassert>
#include <vector>
#include "fancy_object.h"
#include "class.h"
#include "block.h"
#include "string.h"
#include "array.h"
#include "fancy_exception.h"
#include "errors.h"
#include "utils.h"
#include "method.h"
#include "bootstrap/core_classes.h"


namespace fancy {

  FancyObject::FancyObject(Class* _class) :
    _class(_class),
    _metadata(nil)
  {
    init_slots();
  }

  FancyObject::~FancyObject()
  {
  }

  Class* FancyObject::get_class() const
  {
    return _class;
  }

  void FancyObject::set_class(Class* klass)
  {
    if(klass) {
      _class = klass;
      init_slots();
    }
  }

  FancyObject* FancyObject::get_slot(const string &slotname) const
  {
    object_map::const_iterator it = _slots.find(slotname);
    if(it != _slots.end()) {
      return it->second;
    } else {
      return nil;
    }
  }

  void FancyObject::set_slot(const string &slotname, const FancyObject* value)
  {
    assert(value);
    _slots[slotname] = const_cast<FancyObject*>(value);
  }

  void FancyObject::init_slots()
  {
    if(_class) {
      vector<string>::iterator it;
      for(it = _class->instance_slotnames().begin(); 
          it != _class->instance_slotnames().end();
          it++){
        _slots[*it] = nil;
      }
    }
  }

  FancyObject* FancyObject::equal(FancyObject* other) const
  {
    return nil; // default return value
  }

  FancyObject* FancyObject::eval(Scope *scope)
  {
    return this;
  }

  EXP_TYPE FancyObject::type() const
  {
    return EXP_CLASSINSTANCE;
  }

  string FancyObject::to_s() const
  {
    return "<Unkown FancyObject>";
  }

  string FancyObject::inspect() const
  {
    return to_s();
  }

  FancyObject* FancyObject::send_message(const string &method_name, FancyObject* *arguments, int argc, Scope *scope, FancyObject* sender)
  {
    Callable* method = get_method(method_name);
    scope->define("__sender__", sender);
    if(method) {
      if(argc == 0) {
        // take care of private & protected methods
        if(method->is_private()) {
          if(sender->get_class() != this->_class) {
            throw new MethodNotFoundError(method_name, _class, "private method");
          }
        }
        if(method->is_protected()) {
          if(!sender->get_class()->subclass_of(this->_class)) {
            throw new MethodNotFoundError(method_name, _class, "protected method");
          }
        }
        return method->call(this, scope);
      }
      return method->call(this, arguments, argc, scope);
    } else {
      // handle unkown messages, if unkown_message:with*arams is defined
      if(Callable* unkown_message_method = get_method("unknown_message:with_params:")) {
        int size = sizeof(arguments) / sizeof(arguments[0]);
        vector<FancyObject*> arr_vec(arguments, &arguments[size]);
        FancyObject* new_args[2] = { FancyString::from_value(method_name), new Array(arr_vec) };
        return unkown_message_method->call(this, new_args, 2, scope);
      }
      
      // in this case no method is found and we raise a MethodNotFoundError
      FancyException* except = new MethodNotFoundError(method_name, _class);
      throw except;
      return nil;
    }
  }

  FancyObject* FancyObject::send_super_message(const string &method_name, FancyObject* *arguments, int argc, Scope *scope, FancyObject* sender)
  {
    scope->define("__sender__", sender);
    if(Class* superclass = _class->superclass()) {
      Callable* method = superclass->find_method(method_name);
      if(method) {
        if(argc == 0) {
        // take care of private & protected methods
          if(method->is_private()) {
            if(sender->get_class() != this->_class) {
              throw new MethodNotFoundError(method_name, _class, "private method");
            }
          }
          if(method->is_protected()) {
            if(!sender->get_class()->subclass_of(this->_class)) {
              throw new MethodNotFoundError(method_name, _class, "protected method");
            }
          }
          return method->call(this, scope);
        }
        return method->call(this, arguments, argc, scope);
      } else {
        // handle unkown messages, if unkown_message:with_params is defined
        if(Callable* unkown_message_method = _class->superclass()->find_method("unknown_message:with_params:")) {
          int size = sizeof(arguments) / sizeof(arguments[0]);
          vector<FancyObject*> arr_vec(arguments, &arguments[size]);
          FancyObject* new_args[2] = { FancyString::from_value(method_name), new Array(arr_vec) };
          return unkown_message_method->call(this, new_args, 2, scope);
        }
      
        // in this case no method is found and we raise a MethodNotFoundError
        FancyException* except = new MethodNotFoundError(method_name, _class->superclass());
        throw except;
        return nil;
      }
    } else {
      // TODO: create a UndefinedSuperClass exception class or so...
      error("No superclass defined for: ") << _class->to_s() << endl;
      return nil;
    }
  }

  void FancyObject::def_singleton_method(const string &name, Callable* method)
  {
    assert(method);
    _singleton_methods[name] = method;
  }

  void FancyObject::def_private_singleton_method(const string &name, Callable* method)
  {
    assert(method);
    method->set_private();
    _singleton_methods[name] = method;
  }

  void FancyObject::def_protected_singleton_method(const string &name, Callable* method)
  {
    assert(method);
    method->set_protected();
    _singleton_methods[name] = method;
  }

  bool FancyObject::responds_to(const string &method_name)
  {
    if(get_method(method_name)) {
      return true;
    } else {
      return false;
    }
  }

  Callable* FancyObject::get_method(const string &method_name)
  {
    // first of all, check singleton methods
    method_map::const_iterator it = _singleton_methods.find(method_name);
    if(it != _singleton_methods.end()) {
      return it->second;
    } else {
      return _class->find_method(method_name);
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

  Array* FancyObject::methods() const
  {
    vector<FancyObject*> methods;
    
    for(map<string, Callable*>::const_iterator it = _singleton_methods.begin();
        it != _singleton_methods.end();
        it++) {
      if(Method* method = dynamic_cast<Method*>(it->second)) {
        methods.push_back(method);
      } else if(Block* method = dynamic_cast<Block*>(it->second)) {
        methods.push_back(method);
      }
    }
    vector<FancyObject*> class_instance_methods = _class->instance_methods()->values();
    methods.insert(methods.end(), class_instance_methods.begin(), class_instance_methods.end());
    return new Array(methods);
  }

  FancyObject* FancyObject::metadata() const
  {
    return _metadata;
  }
  
  void FancyObject::set_metadata(FancyObject* metadata)
  {
    if(metadata) {
      _metadata = metadata;
    } else {
      errorln("Invalid metadata given!");
    }
  }
}
