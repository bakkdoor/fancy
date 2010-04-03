#ifndef _CLASS_INSTANCE_H_
#define _CLASS_INSTANCE_H_

class FancyObject;
typedef FancyObject* FancyObject_p;

class Class;
class Identifier;
class Method;

class FancyObject : public Expression
{
public:
  FancyObject(Class *_class);
  virtual ~FancyObject();
  
  Class* get_class() const;
  void set_class(Class *klass);

  FancyObject_p get_slot(const string &slotname) const;
  FancyObject_p get_slot(Identifier *slotname) const;

  void set_slot(const string &slotname, const FancyObject_p value);
  void set_slot(Identifier *slotname, const FancyObject_p value);

  virtual FancyObject_p equal(const FancyObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;

  FancyObject_p call_method(const string &method_name, list<FancyObject_p> arguments, Scope *scope);
  void def_singleton_method(const string &name, Callable_p method);
  bool responds_to(const string &method_name);

protected:
  void init_slots();
  Callable_p get_method(const string &method_name);
  Class *_class;
  map<string, FancyObject_p> slots;
  map<string, Callable_p> _singleton_methods;
};

/**
 * some helper macros
 */

#define IS_NIL(obj) \
  obj->type() == OBJ_NIL

#define IS_TRUE(obj) \
  obj->type() == OBJ_TRUE

#define IS_INT(obj) \
  obj->type() == OBJ_INTEGER

#define IS_DOUBLE(obj) \
  obj->type() == OBJ_DOUBLE

#define IS_NUM(obj) \
  (IS_INT(obj) || IS_DOUBLE(obj))

#define NUMVAL(obj) \
  IS_NUM(obj) ? (IS_INT(obj) ? ((Number_p)obj)->intval() : ((Number_p)obj)->doubleval()) : 0

#define IS_IDENT(obj) \
  obj->type() == OBJ_IDENTIFIER

#define IS_SYMBOL(obj) \
  obj->type() == OBJ_SYMBOL

#define IS_STRING(obj) \
  obj->type() == OBJ_STRING

#define IS_HASH(obj) \
  obj->type() == OBJ_HASH

#define IS_ARRAY(obj) \
  obj->type() == OBJ_ARRAY

#define IS_REGEX(obj) \
  obj->type() == OBJ_REGEX

#define IS_METHOD(obj) \
  obj->type() == OBJ_METHOD

#define IS_NATIVEMETHOD(obj) \
  obj->type() == OBJ_NATIVEMETHOD

#define IS_METHODCALL(obj) \
  obj->type() == OBJ_METHODCALL

#define IS_ASSIGNEXPR(obj) \
  obj->type() == OBJ_ASSIGNEXPR

#define IS_RETURNSTATEMENT(obj) \
  obj->type() == OBJ_RETURNSTATEMENT

#define IS_EXPRLIST(obj) \
  obj->type() == OBJ_EXPRLIST

#define IS_METHODDEFEXPR(obj) \
  obj->type() == OBJ_METHODDEFEXPR

#define IS_MODULE(obj) \
  obj->type() == OBJ_MODULE

#define IS_CLASS(obj) \
  obj->type() == OBJ_CLASS

#define IS_CLASSINSTANCE(obj) \
  obj->type() == OBJ_CLASSINSTANCE

#define IS_BLOCK(obj) \
  obj->type() == OBJ_BLOCK

#define IS_BLOCKLITERAL(obj) \
  obj->type() == OBJ_BLOCKLITERAL

#define IS_FILE(obj) \
  obj->type() == OBJ_FILE

#endif /* _CLASS_INSTANCE_H_ */
