#ifndef _BOOTSTRAP_NIL_H_
#define _BOOTSTRAP_NIL_H_

void init_nil_class();

/**
 * NilClass instance methods
 */
FancyObject_p method_NilClass_is_nil(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
FancyObject_p method_NilClass_if_true(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
FancyObject_p method_NilClass_if_false(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

#endif /* _BOOTSTRAP_NIL_H_ */
