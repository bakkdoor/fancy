#ifndef _CLASS_INSTANCE_H_
#define _CLASS_INSTANCE_H_

class ClassInstance;
typedef ClassInstance* ClassInstance_p;

class ClassInstance : public Object
{
public:
  ClassInstance(Class_p _class);
  virtual ~ClassInstance();
  
  Class_p get_class() const;

  Object_p get_slot(const string &slotname) const;
  Object_p get_slot(const Identifier_p slotname) const;

  void set_slot(const string &slotname, const Object_p value);
  void set_slot(const Identifier_p slotname, const Object_p value);

  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;

  Object_p call_method(const string &method_name, vector<Expression_p> arguments);

private:
  void init_slots();

  Class_p _class;
  map<string, Object_p> slots;
};

#endif /* _CLASS_INSTANCE_H_ */
