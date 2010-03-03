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

  Object_p create_instance() const;

  void define_slot(const string &name);
  void define_slot(const Identifier_p name);

  void define_class_slot(const string &name, const Object_p value);
  void define_class_slot(const Identifier_p name, Object_p value);

  void define_method(const string &name, const Method_p method);
  void define_method(const Identifier_p, const Method_p method);

  void define_class_method(const string &name, const Method_p method);
  void define_class_method(const Identifier_p name, const Method_p method);

  void include(const Module_p module);

  vector<string> instance_slotnames() const;
  map<string, Object_p> class_slots() const;

  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;

  Method_p method(const string &name);
  
private:
  /* map<string, Object_p> _slots; */
  vector<string> _instance_slotnames;
  map<string, Object_p> _class_slots;
  Class_p _superclass;
  vector<Module_p> _included_modules;

  map<string, Method_p> _instance_methods;
  map<string, Method_p> _class_methods;
};

#endif /* _CLASS_H_ */
