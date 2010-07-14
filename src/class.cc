#include <cassert>
#include <vector>

#include "class.h"
#include "array.h"
#include "block.h"
#include "method.h"
#include "native_method.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  Class::Class(Class* superclass) :
    FancyObject(ClassClass),
    _name("AnonymousClass"),
    _superclass(superclass)
  {
  }

  Class::Class(const string &name) :
    FancyObject(ClassClass),
    _name(name)
  {
    _superclass = 0;
  }

  Class::Class(const string &name, Class* superclass) : 
    FancyObject(ClassClass),
    _name(name),
    _superclass(superclass)
  {
  }

  Class::~Class()
  {
  }

  FancyObject* Class::create_instance() const
  {
    Class* klass = const_cast<Class*>(this);
    FancyObject* instance = new FancyObject(klass);
    return instance;
  }

  void Class::def_slot(const string &name)
  {
    _instance_slotnames.push_back(name);
  }

  void Class::def_class_slot(const string &name, FancyObject* value)
  {
    assert(value);
    _class_slots[name] = value;
  }

  FancyObject* Class::get_class_slot(const string &identifier) const
  {
    map<string, FancyObject*>::const_iterator it;
    it = _class_slots.find(identifier);
    if(it != _class_slots.end()) {
      return it->second;
    } else {
      return nil;
    }
  }

  void Class::include(Class* klass)
  {
    assert(klass);
    _included_classes.insert(klass);
    _change_num++;
  }

  void Class::def_method(const string &name, Callable* method)
  {
    assert(method);
    _instance_methods[name] = method;
    _change_num++;
  }

  bool Class::undef_method(const string &name)
  {
    if(_instance_methods.find(name) != _instance_methods.end()) {
      _instance_methods.erase(name);
      _change_num++;
      return true;
    }
    return false;
  }

  void Class::def_private_method(const string &name, Callable* method)
  {
    assert(method);
    method->set_private();
    _instance_methods[name] = method;
    _change_num++;
  }

  void Class::def_protected_method(const string &name, Callable* method)
  {
    assert(method);
    method->set_protected();
    _instance_methods[name] = method;
    _change_num++;
  }

  void Class::def_class_method(const string &name, Callable* method)
  {
    assert(method);
    // class methods are nothing else than singleton methods on class objects :)
    this->def_singleton_method(name, method);
    _change_num++;
  }

  bool Class::undef_class_method(const string &name)
  {
    this->undef_singleton_method(name);
  }

  void Class::def_private_class_method(const string &name, Callable* method)
  {
    assert(method);
    this->def_private_singleton_method(name, method);
    _change_num++;
  }

  void Class::def_protected_class_method(const string &name, Callable* method)
  {
    assert(method);
    this->def_protected_singleton_method(name, method);
    _change_num++;
  }

  FancyObject* Class::equal(FancyObject* other) const
  {
    if(!IS_CLASS(other))
      return nil;

    if(this == other)
      return t;

    // TODO: compare slotnames, class_slots, superclass etc.
    return nil;
  }

  Callable* Class::find_method(const string &name)
  {
    // first, try instance methods
    if(_instance_methods.find(name) != _instance_methods.end()) {
      return _instance_methods[name];
    }
    // then, try singleton methods (class methods)
    if(_singleton_methods.find(name) != _singleton_methods.end()) {
      return _singleton_methods[name];
    }
    // then, try methods in included classes
    for(set<Class*>::iterator it = _included_classes.begin();
        it != _included_classes.end();
        it++) {
      if(Callable* method = (*it)->find_method(name)) {
        return method;
      }
    }
    // finally, try getting method from superclass (if there is any)
    if(_superclass) {
      return _superclass->find_method(name);
    }

    return NULL;
  }

  Callable* Class::find_method_in_class(const string &name)
  {
    // first, try instance methods
    if(_instance_methods.find(name) != _instance_methods.end()) {
      return _instance_methods[name];
    }
    // then, try singleton methods (class methods)
    if(_singleton_methods.find(name) != _singleton_methods.end()) {
      return _singleton_methods[name];
    }
    return NULL;
  }

  bool Class::subclass_of(Class* klass)
  {
    if(this == klass)
      return true;

    if(_superclass) {
      return _superclass->subclass_of(klass);
    }

    return false;
  }

  Class* Class::superclass() const
  {
    if(_superclass) {
      return _superclass;
    } else {
      // when no superclass defined, simply return ObjectClass
      // and the recursive class hierarchy begins ;)
      return ObjectClass;
    }
  }

  Array* Class::instance_methods() const
  {
    vector<FancyObject*> methods;

    if(_superclass) {
      vector<FancyObject*> super_methods = _superclass->instance_methods()->values();
      methods.insert(methods.end(), super_methods.begin(), super_methods.end());
    }
    
    for(map<string, Callable*>::const_iterator it = _instance_methods.begin();
        it != _instance_methods.end();
        it++) {
      if(Method* method = dynamic_cast<Method*>(it->second)) {
        methods.push_back(method);
      } else if(NativeMethod* method = dynamic_cast<NativeMethod*>(it->second)) {
        methods.push_back(method);
      } else if(Block* method = dynamic_cast<Block*>(it->second)) {
        methods.push_back(method);
      }
    }

    return new Array(methods);
  }
}
