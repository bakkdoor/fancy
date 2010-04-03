#ifndef _BOOTSTRAP_OBJECT_H_
#define _BOOTSTRAP_OBJECT_H_

void init_object_class();

/**
 * Object class methods
 */

/**
 * New method for creating new instances of classes.
 * It is expected, that self (the receiver) is a class object.
 */
FancyObject_p class_method_Object_new(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Same as above, but also expecting arguments and passing them on to
 * the initialize: method of the class.
 */
FancyObject_p class_method_Object_new_with_arg(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Boolean conjunction.
 */
FancyObject_p method_Object_and(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Boolean disjunction.
 */
FancyObject_p method_Object_or(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Boolean negation.
 * In Fancy, everything non-nil is logically true.
 */
FancyObject_p method_Object_not(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Returns string representation of object.
 */
FancyObject_p method_Object_to_s(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Returns detailed string representation of object.
 */
FancyObject_p method_Object_inspect(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Returns the class of the object.
 */
FancyObject_p method_Object_class(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Defines singleton method on object.
 */
FancyObject_p method_Object_define_singleton_method__with(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Checks equality of objects.
 */
FancyObject_p method_Object_eq(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Checks if an object is an instance of a given Class.
 */
FancyObject_p method_Object_is_a(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

#endif /* _BOOTSTRAP_OBJECT_H_ */
