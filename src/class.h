#ifndef _CLASS_H_
#define _CLASS_H_

class Class;
typedef Class* Class_p;

class Class : public Module
{
public:
  Class(const string &name);
  Class(const string &name, Class_p superclass);
  virtual ~Class();

  string name() const;

  FancyObject_p create_instance() const;
  FancyObject_p create_instance(NativeObject_p native_value) const;

  void def_slot(const string &name);
  void def_slot(const Identifier_p name);

  void def_class_slot(const string &name, const FancyObject_p value);
  void def_class_slot(const Identifier_p name, FancyObject_p value);

  FancyObject_p get_class_slot(const string &identifier) const;

  void def_method(const string &name, const Callable_p method);
  void def_method(const Identifier_p, const Callable_p method);

  void def_class_method(const string &name, const Callable_p method);
  void def_class_method(const Identifier_p name, const Callable_p method);

  void include(const Module_p module);

  vector<string> instance_slotnames() const;
  map<string, FancyObject_p> class_slots() const;

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;

  Callable_p find_method(const string &name);

private:
  /* map<string, NativeObject_p> _slots; */
  string _name;
  vector<string> _instance_slotnames;
  map<string, FancyObject_p> _class_slots;
  Class_p _superclass;
  vector<Module_p> _included_modules;

  map<string, Callable_p> _instance_methods;
};

#endif /* _CLASS_H_ */
