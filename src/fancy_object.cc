#include "../vendor/gc/include/gc.h"
#include "../vendor/gc/include/gc_cpp.h"
#include "../vendor/gc/include/gc_allocator.h"

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
    _metadata(nil),
    _change_num(0),
    _has_metaclass(false)
  {
    init_slots();
  }

  Class* FancyObject::get_class() const
  {
    if(!_has_metaclass) {
      return _class;
    } else {
      return _class->superclass();
    }
  }

  Class* FancyObject::metaclass()
  {
    if(!_has_metaclass) {
      _class = new Class("Metaclass<" + this->to_s() + ">", _class);
      _has_metaclass = true;
    }
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
    Class* klass = this->get_class();
    if(klass) {
      vector<string>::iterator it;
      for(it = klass->instance_slotnames().begin();
          it != klass->instance_slotnames().end();
          it++){
        _slots[*it] = nil;
      }
    }
  }

  FancyObject* FancyObject::equal(FancyObject* other) const
  {
    return nil; // return default value
  }


  string FancyObject::to_sexp() const
  {
    return "\"UNKOWN SEXP FOR EXP_CLASSINSTANCE\"";
  }

  string FancyObject::inspect() const
  {
    return to_s() + " : " + get_class()->name();
  }

  FancyObject* FancyObject::send_message(const string &method_name, FancyObject* *arguments, int argc, Scope *scope, FancyObject* sender)
  {
    Callable* method = get_method(method_name);
    scope->set_current_sender(sender);
    if(method) {
      if(argc == 0) {
        return method->call(this, scope, sender);
      }
      return method->call(this, arguments, argc, scope, sender);
    } else {
      // handle unkown messages, if unkown_message:with_params is defined
      return handle_unknown_message(method_name, arguments, argc, scope, sender);
    }
  }

  FancyObject* FancyObject::send_super_message(const string &method_name, FancyObject* *arguments, int argc, Scope *scope, FancyObject* sender)
  {
    scope->set_current_sender(sender);
    if(Class* superclass = this->get_class()->superclass()) {
      Callable* method = superclass->find_method(method_name);
      if(method) {
        if(argc == 0) {
          return method->call(this, scope, sender);
        }
        return method->call(this, arguments, argc, scope, sender);
      } else {
        // no method found -> handle unkown message
        return handle_unknown_message(method_name, arguments, argc, scope, sender, true);
      }
    } else {
      // TODO: create a UndefinedSuperClass exception class or so...
      error("No superclass defined for: ") << this->get_class()->to_s() << endl;
      return nil;
    }
  }

  FancyObject* FancyObject::handle_unknown_message(const string &method_name, FancyObject* *arguments, int argc, Scope *scope, FancyObject* sender, bool from_super)
  {
    Callable* unkown_message_method = NULL;

    if(from_super) {
      unkown_message_method = this->get_class()->superclass()->find_method("unknown_message:with_params:");
    } else {
      unkown_message_method = get_method("unknown_message:with_params:");
    }

    if(unkown_message_method) {
      // create array of arguments for unkown_message:with_params: method
      // including the message name and an array including the old
      // arguments for further use within unkown_message:with_params:
      int size = sizeof(arguments) / sizeof(arguments[0]);
      vector<FancyObject*> arr_vec(arguments, &arguments[size]);
      FancyObject* new_args[2] = { FancyString::from_value(method_name), new Array(arr_vec) };
      return unkown_message_method->call(this, new_args, 2, scope, sender);
    }

    // in this case no method is found and we raise a MethodNotFoundError
    FancyException* except = new MethodNotFoundError(method_name, this->get_class());
    throw except;
    return nil;
  }

  void FancyObject::def_singleton_method(const string &name, Callable* method)
  {
    assert(method);
    this->metaclass()->def_method(name, method);
    _change_num++;
  }

  bool FancyObject::undef_singleton_method(const string &name)
  {
    if(this->metaclass()->find_method(name)) {
      this->metaclass()->undef_method(name);
      _change_num++;
      return true;
    }
    return false;
  }


  void FancyObject::def_private_singleton_method(const string &name, Callable* method)
  {
    assert(method);
    this->metaclass()->def_private_method(name, method);
    _change_num++;
  }

  void FancyObject::def_protected_singleton_method(const string &name, Callable* method)
  {
    assert(method);
    this->metaclass()->def_protected_method(name, method);
    _change_num++;
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
    return _class->find_method(method_name);
  }

  Array* FancyObject::methods() const
  {
    return new Array(_class->instance_methods()->values());
  }

}
