#ifndef _CORE_METHODS_H_
#define _CORE_METHODS_H_

extern Class *ClassClass;
extern Class *ModuleClass;
extern Class *ObjectClass;
extern Class *NilClass;
extern Class *TClass;
extern Class *StringClass;
extern Class *SymbolClass;
extern Class *NumberClass;
extern Class *RegexClass;
extern Class *ArrayClass;
extern Class *MethodClass;
extern Class *MethodCallClass;

extern FancyObject *nil;
extern FancyObject *t;


void init_core_classes();
void init_core_methods();
void init_global_objects();

/**
 * Sets up the global scope with predefined functions etc.
 */
void init_global_scope();

/**
 * Console class methods
 */
FancyObject_p class_method_Console_println(list<Expression_p> args, Scope *scope);

#endif /* _CORE_METHODS_H_ */
