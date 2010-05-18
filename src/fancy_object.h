#ifndef _CLASS_INSTANCE_H_
#define _CLASS_INSTANCE_H_

namespace fancy {

  class FancyObject;
  typedef FancyObject* FancyObject_p;

  class Class;
  class Identifier;
  class Method;
  class Array;

  typedef map<string, FancyObject_p> object_map;
  typedef map<string, Callable_p> method_map;

  /**
   * Base class for all built-in object types in Fancy.
   */
  class FancyObject : public Expression
  {
  public:
    /**
     * Constructor that takes the Class object for the FancyObject.
     * @param _class The Class object that represents the Class of the Object.
     */
    FancyObject(Class *_class);
    virtual ~FancyObject();
  
    /**
     * Returns the Class of the object.
     * @return Class object of the object.
     */
    Class* get_class() const;

    /**
     * Sets the Class object of the object.
     * @param klass Class object of the object.
     */
    void set_class(Class *klass);

    /**
     * Returns the value of a slot or nil, if not defined.
     * @param slotname The name (identifier) of the slot to get the
     * value from.
     * @return The slotvalue for a given slotname or nil, if not
     * defined.
     */
    FancyObject_p get_slot(const string &slotname) const;
    FancyObject_p get_slot(Identifier *slotname) const;

    /**
     * Sets the slot for a given name with a given value.
     * @param slotname The name (idenfitier) of the slot.
     * @param value The value to be set for the slot.
     */
    void set_slot(const string &slotname, const FancyObject_p value);
    void set_slot(Identifier *slotname, const FancyObject_p value);

    /**
     * Indicates, if two objects are equal.
     * @param other The other object to compare this one to.
     * @return true, if they are equal, nil otherwise.
     */
    virtual FancyObject_p equal(const FancyObject_p other) const;

    /**
     * Inherited from Expression.
     */
    virtual FancyObject_p eval(Scope *scope);
    virtual OBJ_TYPE type() const;

    /**
     * Returns a C++ string representation of the object (for ouput
     * purposes).
     * @return C++ string representation of the object.
     */
    virtual string to_s() const;

    /**
     * Returns a C++ string representation with additional information
     * (e.g. Class of the object).
     * @return C++ stirng representation with additional information.
     */
    virtual string inspect() const;

    /**
     * Calls a method with arguments in a given scope.
     * @param method_name Name of the method (e.g. "is_a?:")
     * @param arguments Array of FancyObjects that holds the arguments for the methodcall.
     * @param argc Amount of arguments passed.
     * @param scope Scope in which the methodcall should evaluate.
     * @return The (return) value of the methodcall.
     */
    FancyObject_p call_method(const string &method_name, FancyObject_p *arguments, int argc, Scope *scope);

    /**
     * Calls a method on its superclass with arguments in a given scope.
     * @param method_name Name of the method (e.g. "is_a?:")
     * @param arguments Array of FancyObjects that holds the arguments for the methodcall.
     * @param argc Amount of arguments passed.
     * @param scope Scope in which the methodcall should evaluate.
     * @return The (return) value of the methodcall.
     */
    FancyObject_p call_super_method(const string &method_name, FancyObject_p *arguments, int argc, Scope *scope);

    /**
     * Define a singleton method on a FancyObject.
     * @param name Name of the singleton method.
     * @param method A Callable that holds the method's body.
     */
    void def_singleton_method(const string &name, Callable_p method);

    /**
     * Indicates, if a FancyObject responds to a given methodname (has
     * a method definition for it).
     * @param method_name Name of the method to check.
     * @return true, if this is the case, false otherwise.
     */
    bool responds_to(const string &method_name);

    /**
     * Returns a Callable representing the method for a given methodname, if defined.
     * @param method_name Name of the method to get.
     * @return Callable representing the method or NULL, if not defined.
     */
    Callable_p get_method(const string &method_name);

    /**
     * Returns a C++ string holding the documentation string for the FancyObject.
     * return C++ string with documentation string.
     */
    string docstring() const;

    /**
     * Sets the docstring for the FancyObject.
     * @param docstring The documentation string to be set.
     */
    void set_docstring(const string &docstring);

    /**
     * Returns all methods of this FancyObject in an Array.
     * @return Array with all methods of the FancyObject.
     */
    Array* methods() const;
  protected:
    void init_slots();
    Class *_class;
    map<string, FancyObject_p> _slots;
    map<string, Callable_p> _singleton_methods;
    string _docstring;
  };

}

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
