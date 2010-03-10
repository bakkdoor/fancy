#ifndef _CLASS_INSTANCE_H_
#define _CLASS_INSTANCE_H_

class FancyObject;
typedef FancyObject* FancyObject_p;

class Class;
class Identifier;
class Method;
class NativeMethod;

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
  virtual string to_s() const;

  FancyObject_p call_method(const string &method_name, list<Expression_p> arguments, Scope *scope);

  NativeObject_p native_value() const;

  void define_singleton_method(const string &name, Method *method);
  void define_native_singleton_method(NativeMethod *method);

private:
  void init_slots();
 
  Class *_class;
  NativeObject_p _native_value;
  map<string, FancyObject_p> slots;

  map<string, Method*> _singleton_methods;
  map<string, NativeMethod*> _native_singleton_methods;
};

#endif /* _CLASS_INSTANCE_H_ */
