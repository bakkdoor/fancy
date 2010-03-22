#ifndef _BOOTSTRAP_ARRAY_H_
#define _BOOTSTRAP_ARRAY_H_

void init_array_class();

/**
 * Array instance methods
 */
FancyObject_p method_Array_each(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

#endif /* _BOOTSTRAP_ARRAY_H_ */
