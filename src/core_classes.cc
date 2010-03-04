#include "includes.h"

/**
 * Core Classes
 */
Class_p ObjectClass;
Class_p NilClass;
Class_p TClass;
Class_p StringClass;
Class_p NumberClass;

/**
 * Global Singleton Objects
 */
ClassInstance_p nil;
ClassInstance_p t;


// void init_global_scope()
// {
//   global_scope = new Scope();
//   global_scope->define("nil", nil);
//   global_scope->define("t", t);
// }

void init_core_classes()
{
  ObjectClass = new Class();
  NilClass = new Class(ObjectClass);
  TClass = new Class(ObjectClass);
  StringClass = new Class(ObjectClass);
  NumberClass = new Class(ObjectClass);
}

void init_global_objects()
{
  nil = new ClassInstance(NilClass, new Nil());
  t = new ClassInstance(TClass, new T());
}
