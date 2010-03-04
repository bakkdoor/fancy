#ifndef _CLASS_INSTANCE_H_
#define _CLASS_INSTANCE_H_

class FancyObject;
typedef FancyObject* FancyObject_p;

class Class;
class Identifier;

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

  FancyObject_p call_method(const string &method_name, vector<Expression_p> arguments);

  NativeObject_p native_value() const;

private:
  void init_slots();
 
  Class *_class;
  NativeObject_p _native_value;
  map<string, FancyObject_p> slots;
};

#endif /* _CLASS_INSTANCE_H_ */
