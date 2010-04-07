#ifndef _BOOTSTRAP_HASH_H
#define _BOOTSTRAP_HASH_H

void init_hash_class();

/**
 * Hash class methods
 */
FancyObject_p class_method_Hash_new(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

/**
 * Hash instance methods
 */

FancyObject_p method_Hash_size(FancyObject_p self, list<FancyObject_p> args, Scope *scope);


#endif /* _BOOTSTRAP_HASH_H */
