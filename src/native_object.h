#ifndef _OBJECT_H_
#define _OBJECT_H_

enum OBJ_TYPE {
  OBJ_NIL = 0,
  OBJ_TRUE,
  OBJ_INTEGER,
  OBJ_DOUBLE,
  OBJ_IDENTIFIER,
  OBJ_SYMBOL,
  OBJ_STRING,
  OBJ_HASH,
  OBJ_REGEX,
  OBJ_ARRAY,
  OBJ_METHOD,
  OBJ_NATIVEMETHOD,
  OBJ_METHODCALL,
  OBJ_OPCALL,
  OBJ_ASSIGNEXPR,
  OBJ_METHODDEFEXPR,
  OBJ_MODULE,
  OBJ_CLASS,
  OBJ_CLASSINSTANCE,
  OBJ_CLASSDEFEXPR,
  OBJ_BLOCK,
  OBJ_FILE
};

class NativeObject;
class Hash;
typedef NativeObject* NativeObject_p;

class NativeObject : public Expression
{
 public:
  NativeObject(OBJ_TYPE type);
  ~NativeObject();

  OBJ_TYPE type() const;
  virtual string to_s() const;

 private:
  OBJ_TYPE obj_type;
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

#define IS_FILE(obj) \
  obj->type() == OBJ_FILE

#endif /* _OBJECT_H_ */
