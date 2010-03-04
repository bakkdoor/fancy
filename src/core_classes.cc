#include "includes.h"

/**
 * Core Classes
 */
Class_p ClassClass = 0;
Class_p ModuleClass;
Class_p ObjectClass;
Class_p NilClass;
Class_p TClass;
Class_p StringClass;
Class_p SymbolClass;
Class_p NumberClass;
Class_p RegexClass;
Class_p ArrayClass;
Class_p MethodClass;
Class_p MethodCallClass;

/**
 * Global Singleton Objects
 */
FancyObject_p nil;
FancyObject_p t;


/**
 * Runtime initialization functions.
 */
void init_core_classes()
{
  ClassClass = new Class();
  ModuleClass = new Class();
  ObjectClass = new Class();
  NilClass = new Class(ObjectClass);
  TClass = new Class(ObjectClass);
  StringClass = new Class(ObjectClass);
  SymbolClass = new Class(ObjectClass);
  NumberClass = new Class(ObjectClass);
  RegexClass = new Class(ObjectClass);
  ArrayClass = new Class(ObjectClass);
  MethodClass = new Class(ObjectClass);
  MethodCallClass = new Class(ObjectClass); 
}

void init_global_objects()
{
  nil = new FancyObject(NilClass, new Nil());
  t = new FancyObject(TClass, new T());
}

void init_global_scope()
{
  global_scope = new Scope();

  /* define classes */
  global_scope->define("Class", ClassClass);
  global_scope->define("Module", ModuleClass);
  global_scope->define("Object", ObjectClass);
  global_scope->define("NilClass", NilClass);
  global_scope->define("TClass", TClass);
  global_scope->define("String", StringClass);
  global_scope->define("Symbol", SymbolClass);
  global_scope->define("Number", NumberClass);
  global_scope->define("Regex", RegexClass);
  global_scope->define("Array", ArrayClass);
  global_scope->define("Method", MethodClass);
  global_scope->define("MethodCall", MethodClass);
  
  /* define singleton objects */
  global_scope->define("nil", nil);
  global_scope->define("t", t);
}
