#ifndef _CLASS_H_
#define _CLASS_H_

class Class;
typedef Class* Class_p;

class Class : public Module
{
public:
  Class();
  Class(Class_p superclass);
  virtual ~Class();

  FancyObject_p create_instance() const;
  FancyObject_p create_instance(NativeObject_p native_value) const;

  void def_slot(const string &name);
  void def_slot(const Identifier_p name);

  void def_class_slot(const string &name, const NativeObject_p value);
  void def_class_slot(const Identifier_p name, NativeObject_p value);

  void def_method(const string &name, const Method_p method);
  void def_method(const Identifier_p, const Method_p method);

  void def_class_method(const string &name, const Method_p method);
  void def_class_method(const Identifier_p name, const Method_p method);

  void def_native_method(const NativeMethod_p method);
  void def_native_class_method(const NativeMethod_p method);

  void include(const Module_p module);

  vector<string> instance_slotnames() const;
  map<string, NativeObject_p> class_slots() const;

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual string to_s() const;

  Method_p find_method(const string &name);
  NativeMethod_p find_native_method(const string &name);
  
private:
  /* map<string, NativeObject_p> _slots; */
  vector<string> _instance_slotnames;
  map<string, NativeObject_p> _class_slots;
  Class_p _superclass;
  vector<Module_p> _included_modules;

  map<string, Method_p> _instance_methods;
  map<string, NativeMethod_p> _native_instance_methods;
};

#endif /* _CLASS_H_ */
