#include "includes.h"

/**
 * Core Classes
 */
Class_p ClassClass;
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


/**
 * Runtime initialization functions.
 */
void init_core_classes()
{
  ClassClass = new Class();
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

void init_global_scope()
{
  global_scope = new Scope();

  /* define classes */
  global_scope->define("Object", ObjectClass);
  
  /* define singleton objects */
  global_scope->define("nil", nil);
  global_scope->define("t", t);
}
