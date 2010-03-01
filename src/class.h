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
  void define_slot(Identifier_p name, Object_p value);
  void define_class_slot(Identifier_p name, Object_p value);
  void include(Module_p module);

  map<Identifier_p, Object_p> slots() const;
  map<Identifier_p, Object_p> class_slots() const;
  
private:
  map<Identifier_p, Object_p> _slots;
  map<Identifier_p, Object_p> _class_slots;
  Class_p _superclass;
  vector<Module_p> _included_modules;
};

#endif /* _CLASS_H_ */
