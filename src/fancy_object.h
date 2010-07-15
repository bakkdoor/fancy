#ifndef _CLASS_INSTANCE_H_
#define _CLASS_INSTANCE_H_

#include <map>
#include <string>

#include "expression.h"
#include "callable.h"

using namespace std;

namespace fancy {

  class Class;
  class Method;
  class Array;
  class Scope;

  typedef map<string, FancyObject*> object_map;
  typedef map<string, Callable*> method_map;
      
#define CHANGED(obj, last_chnum)                \
      (obj->change_num() != last_chnum)

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
    virtual ~FancyObject() {}
  
    /**
     * Returns the Class of the object.
     * @return Class object of the object.
     */
    Class* get_class() const { return _class; }

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
    FancyObject* get_slot(const string &slotname) const;

    /**
     * Sets the slot for a given name with a given value.
     * @param slotname The name (idenfitier) of the slot.
     * @param value The value to be set for the slot.
     */
    void set_slot(const string &slotname, const FancyObject* value);

    /**
     * Indicates, if two objects are equal.
     * @param other The other object to compare this one to.
     * @return true, if they are equal, nil otherwise.
     */
    virtual FancyObject* equal(FancyObject* other) const;

    /**
     * Inherited from Expression.
     */
    virtual FancyObject* eval(Scope *scope) { return this; }
    virtual EXP_TYPE type() const { return EXP_CLASSINSTANCE; }
    virtual string to_sexp() const;

    /**
     * Returns a C++ string representation of the object (for ouput
     * purposes).
     * @return C++ string representation of the object.
     */
    virtual string to_s() const { return "<Unkown FancyObject>"; }

    /**
     * Returns a C++ string representation with additional information
     * (e.g. Class of the object).
     * @return C++ stirng representation with additional information.
     */
    virtual string inspect() const { return to_s(); }

    /**
     * Calls a method with arguments in a given scope.
     * @param method_name Name of the method (e.g. "is_a?:")
     * @param arguments Array of FancyObjects that holds the arguments for the message send.
     * @param argc Amount of arguments passed.
     * @param scope Scope in which the message send should evaluate.
     * @param sender Object, that tries to send the message to this Object.
     * @return The (return) value of the message send.
     */
    FancyObject* send_message(const string &method_name, FancyObject* *arguments, int argc, Scope *scope, FancyObject* sender);

    /**
     * Calls a method on its superclass with arguments in a given scope.
     * @param method_name Name of the method (e.g. "is_a?:")
     * @param arguments Array of FancyObjects that holds the arguments for the message send.
     * @param argc Amount of arguments passed.
     * @param scope Scope in which the message send should evaluate.
     * @param sender Object, that tries to send the message to this Object.
     * @return The (return) value of the message send.
     */
    FancyObject* send_super_message(const string &method_name, FancyObject* *arguments, int argc, Scope *scope, FancyObject* sender);

    /**
     * Handles unkown messages (sends unknown_message:params: message
     * to self, if defined or throws an NoMethodError)
     * @param method_name Name of the method (e.g. "foobar:")
     * @param arguments Array of FancyObjects that holds the arguments for the message send.
     * @param argc Amount of arguments passed.
     * @param scope Scope in which the message send should evaluate.
     * @param sender Object, that tries to send the message to this Object.
     * @return The (return) value of the message send.
     */
    FancyObject* handle_unknown_message(const string &method_name, FancyObject* *arguments, int argc, Scope *scope, FancyObject* sender, bool from_super = false);

    /**
     * Define a singleton method on a FancyObject.
     * @param name Name of the singleton method.
     * @param method A Callable that holds the method's body.
     */
    void def_singleton_method(const string &name, Callable* method);

    /**
     * Undefines an existing singleton method for the Object.
     * @param name the name of the singleton method to be deleted
     * (undefined).
     * @return true, if method existed, false otherwise.
     */
    bool undef_singleton_method(const string &name);

    /**
     * Define a private singleton method on a FancyObject.
     * @param name Name of the private singleton method.
     * @param method A Callable that holds the method's body.
     */
    void def_private_singleton_method(const string &name, Callable* method);

    /**
     * Define a protected singleton method on a FancyObject.
     * @param name Name of the protected singleton method.
     * @param method A Callable that holds the method's body.
     */
    void def_protected_singleton_method(const string &name, Callable* method);

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
    Callable* get_method(const string &method_name);

    /**
     * Returns a C++ string holding the documentation string for the FancyObject.
     * return C++ string with documentation string.
     */
    string docstring() const { return _docstring; }

    /**
     * Sets the docstring for the FancyObject.
     * @param docstring The documentation string to be set.
     */
    void set_docstring(const string &docstring) { _docstring = docstring; }

    /**
     * Returns all methods of this FancyObject in an Array.
     * @return Array with all methods of the FancyObject.
     */
    Array* methods() const;

    /**
     * Returns the metadata Hash attached to this object.
     * @return The metadata Hash attached to this object.
     */
    FancyObject* metadata() const { return _metadata; }

    /**
     * Sets the metadata for this object.
     * @param metadata The metadata for this object.
     */
    void set_metadata(FancyObject* metadata) { _metadata = metadata; }

    unsigned int change_num() const { return _change_num; }

  protected:
    void init_slots();
    Class *_class;
    map<string, FancyObject*> _slots;
    map<string, Callable*> _singleton_methods;
    string _docstring;
    FancyObject* _metadata;
    unsigned int _change_num; // counter for number of method changes (used for method caching)
  };

}

/**
 * some helper macros
 */

#define IS_NIL(obj) \
  obj->type() == EXP_NIL

#define IS_TRUE(obj) \
  obj->type() == EXP_TRUE

#define IS_INT(obj) \
  obj->type() == EXP_INTEGER

#define IS_DOUBLE(obj) \
  obj->type() == EXP_DOUBLE

#define IS_NUM(obj) \
  (IS_INT(obj) || IS_DOUBLE(obj))

#define NUMVAL(obj) \
  IS_NUM(obj) ? (IS_INT(obj) ? ((Number*)obj)->intval() : ((Number*)obj)->doubleval()) : 0

#define IS_IDENT(obj) \
  obj->type() == EXP_IDENTIFIER

#define IS_SYMBOL(obj) \
  obj->type() == EXP_SYMBOL

#define IS_STRING(obj) \
  obj->type() == EXP_STRING

#define IS_HASH(obj) \
  obj->type() == EXP_HASH

#define IS_ARRAY(obj) \
  obj->type() == EXP_ARRAY

#define IS_REGEX(obj) \
  obj->type() == EXP_REGEX

#define IS_METHOD(obj) \
  obj->type() == EXP_METHOD

#define IS_NATIVEMETHOD(obj) \
  obj->type() == EXP_NATIVEMETHOD

#define IS_METHODCALL(obj) \
  obj->type() == EXP_METHODCALL

#define IS_ASSIGNEXPR(obj) \
  obj->type() == EXP_ASSIGNEXPR

#define IS_RETURNSTATEMENT(obj) \
  obj->type() == EXP_RETURNSTATEMENT

#define IS_EXPRLIST(obj) \
  obj->type() == EXP_EXPRLIST

#define IS_METHODDEFEXPR(obj) \
  obj->type() == EXP_METHODDEFEXPR

#define IS_MODULE(obj) \
  obj->type() == EXP_MODULE

#define IS_CLASS(obj) \
  obj->type() == EXP_CLASS

#define IS_CLASSINSTANCE(obj) \
  obj->type() == EXP_CLASSINSTANCE

#define IS_BLOCK(obj) \
  obj->type() == EXP_BLOCK

#define IS_BLOCKLITERAL(obj) \
  obj->type() == EXP_BLOCKLITERAL

#define IS_FILE(obj) \
  obj->type() == EXP_FILE

#endif /* _CLASS_INSTANCE_H_ */
