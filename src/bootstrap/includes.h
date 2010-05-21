#ifndef _BOOTSTRAP_INCLUDES_H_
#define _BOOTSTRAP_INCLUDES_H_

#include "../includes.h"

#include "core_classes.h"

#define EXPECT_ARGS(method_name, amount)                                \
  if(argc != amount) {                                                  \
    error(method_name) << " expects " << amount << " arguments." << endl; \
    return nil;                                                         \
  }                                                                     

/**
 * Macro that generates a NativeMethod (instance method) function name.
 * E.g.: METHOD_FUNC(ObjectClass, to_s) -> ObjectClass__to_s
 */
#define METHOD_FUNC(class, method_name)    \
  class ## __ ## method_name

/**
 * Macro that generates a NativeMethod (class method) function name.
 * E.g.: CLASSMETHOD_FUNC(ObjectClass, new) -> ObjectClass_class__new
 */
#define CLASSMETHOD_FUNC(class, method_name)    \
  class ## _class__ ## method_name

/**
 * Macro, that generates a NativeMethod (instance method) function
 * prototype declaration.
 * E.g.: METHOD(ObjectClass, to_s)
 * -> FancyObject_p ObjectClass__to_s(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
 */
#define METHOD(class, method_name)                                       \
  FancyObject_p METHOD_FUNC(class, method_name)(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)

/**
 * Macro, that generates a NativeMethod (class method) function
 * prototype declaration.
 * E.g.: CLASSMETHOD(ObjectClass, new)
 * -> FancyObject_p ObjectClass__new(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
 */
#define CLASSMETHOD(class, method_name)                                       \
  FancyObject_p CLASSMETHOD_FUNC(class, method_name)(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)

/**
 * Generates the NativeMethod (instance method) prototype declaration,
 * followed by defining the NativeMethod on the specified class.
 */
#define DEF_METHOD(class, method_name, docstring, method_func)          \
  METHOD(class, method_func);                                           \
  class->def_method(method_name, new NativeMethod(method_name, docstring, METHOD_FUNC(class, method_func)))

/**
 * Generates the NativeMethod (class method) prototype declaration,
 * followed by defining the NativeMethod on the specified class.
 */
#define DEF_CLASSMETHOD(klass, method_name, docstring, method_func)     \
  CLASSMETHOD(klass, method_func);                                      \
  klass->def_class_method(method_name, new NativeMethod(method_name, docstring, CLASSMETHOD_FUNC(klass, method_func)))

#endif /* _BOOTSTRAP_INCLUDES_H_ */
