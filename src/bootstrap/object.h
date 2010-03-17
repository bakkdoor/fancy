#ifndef _BOOTSTRAP_OBJECT_H_
#define _BOOTSTRAP_OBJECT_H_

void init_object_class();

/**
 * Object class methods
 */
FancyObject_p class_method_Object_new(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
FancyObject_p class_method_Object_new_with_arg(FancyObject_p self, list<FancyObject_p> args, Scope *scope);


#endif /* _BOOTSTRAP_OBJECT_H_ */
