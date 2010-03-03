#ifndef _OBJECT_H_
#define _OBJECT_H_

/**
 * This file contains the definition of the gobject structure, as well
 * as some useful creator-functions for the built-in object types.
 */

enum OBJ_TYPE {
  OBJ_NIL,
  OBJ_T,
  OBJ_INTEGER,
  OBJ_DOUBLE,
  OBJ_IDENTIFIER,
  OBJ_SYMBOL,
  OBJ_STRING,
  OBJ_HASH,
  OBJ_REGEX,
  OBJ_ARRAY,
  OBJ_METHOD,
  OBJ_BIF,
  OBJ_METHODCALL,
  OBJ_ASSIGNEXPR,
  OBJ_METHODDEFEXPR,
  OBJ_MODULE,
  OBJ_CLASS,
  OBJ_CLASSINSTANCE
};

class Object;
class Hash;
typedef Object* Object_p;

class Object : public Expression
{
 public:
  Object(OBJ_TYPE type);
  Object(OBJ_TYPE type, bool quoted);
  ~Object();

  OBJ_TYPE type() const;
  unsigned int object_id() const;

  virtual string to_s() const;
  bool is_quoted() const;
  virtual void set_quoted(bool quoted);

  Object_p set_slot(string name, Object_p value);
  Object_p get_slot(string name) const;
  Hash* slot_values() const;

 private:
  OBJ_TYPE obj_type;
  bool quoted;
  unsigned int obj_id;
  
  map<string, Object_p> _slot_values;
  
  static unsigned int obj_counter;
};

/**
 * some helper macros
 */

#define IS_NIL(obj) \
  obj->type() == OBJ_NIL

#define IS_T(obj) \
  obj->type() == OBJ_T

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

#define IS_REGEX(obj) \
  obj->type() == OBJ_REGEX

#define IS_METHOD(obj) \
  obj->type() == OBJ_METHOD

#define IS_BIF(obj) \
  obj->type() == OBJ_BIF

#define IS_METHODCALL(obj) \
  obj->type() == OBJ_METHODCALL

#define IS_ASSIGNEXPR(obj) \
  obj->type() == OBJ_ASSIGNEXPR

#define IS_METHODDEFEXPR(obj) \
  obj->type() == OBJ_METHODDEFEXPR

#define IS_MODULE(obj) \
  obj->type() == OBJ_MODULE

#define IS_CLASS(obj) \
  obj->type() == OBJ_CLASS

#define IS_CLASSINSTANCE(obj) \
  obj->type() == OBJ_CLASSINSTANCE

/**
 * nil & t objects 
 */
extern Object_p nil;
extern Object_p t;

void init_global_objects();

#endif /* _OBJECT_H_ */
