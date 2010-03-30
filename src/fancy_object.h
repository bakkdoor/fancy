#ifndef _CLASS_INSTANCE_H_
#define _CLASS_INSTANCE_H_

class FancyObject;
typedef FancyObject* FancyObject_p;

class Class;
class Identifier;
class Method;

class FancyObject : public NativeObject
{
public:
  FancyObject(Class *_class);
  FancyObject(Class *_class, NativeObject_p native_value);
  virtual ~FancyObject();
  
  Class* get_class() const;
  void set_class(Class *klass);

  FancyObject_p get_slot(const string &slotname) const;
  FancyObject_p get_slot(Identifier *slotname) const;

  void set_slot(const string &slotname, const FancyObject_p value);
  void set_slot(Identifier *slotname, const FancyObject_p value);

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;

  FancyObject_p call_method(const string &method_name, list<FancyObject_p> arguments, Scope *scope);
  NativeObject_p native_value() const;
  void def_singleton_method(const string &name, Callable_p method);
  bool responds_to(const string &method_name);

protected:
  void init_slots();
  Callable_p get_method(const string &method_name);
 
  Class *_class;
  NativeObject_p _native_value;
  map<string, FancyObject_p> slots;

  map<string, Callable_p> _singleton_methods;
};

#endif /* _CLASS_INSTANCE_H_ */
