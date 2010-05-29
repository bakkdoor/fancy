#include <cassert>
#include <vector>

#include "class.h"
#include "array.h"
#include "block.h"
#include "method.h"
#include "native_method.h"
#include "bootstrap/core_classes.h"

namespace fancy {

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

  string Class::name() const
  {
    return _name;
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
  }

  vector<string> Class::instance_slotnames() const
  {
    return _instance_slotnames;
  }

  map<string, FancyObject*> Class::class_slots() const
  {
    return _class_slots;
  }

  void Class::def_method(const string &name, Callable* method)
  {
    assert(method);
    _instance_methods[name] = method;
  }

  void Class::def_class_method(const string &name, Callable* method)
  {
    assert(method);
    // class methods are nothing else than singleton methods on class objects :)
    this->def_singleton_method(name, method);
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

  EXP_TYPE Class::type() const
  {
    return EXP_CLASS;
  }

  string Class::to_s() const
  {
    return _name;
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

    return 0;
  }

  bool Class::subclass_of(Class* klass)
  {
    if(this == klass)
      return true;

    if(_superclass) {
      if(_superclass == klass) {
        return true;
      } else {
        return _superclass->subclass_of(klass);
      }
    }
    return false;
  }

  Class* Class::superclass() const
  {
    return _superclass;
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
