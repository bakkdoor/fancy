#include "includes.h"

/**
 * Core Classes
 */
Class_p ClassClass = 0;
Class_p ModuleClass;
Class_p ObjectClass;
Class_p NilClass;
Class_p TClass;
Class_p FalseClass;
Class_p StringClass;
Class_p SymbolClass;
Class_p NumberClass;
Class_p RegexClass;
Class_p ArrayClass;
Class_p MethodClass;
Class_p MethodCallClass;

Class_p ConsoleClass;

/**
 * Global Singleton Objects
 */
FancyObject_p nil;
FancyObject_p t;
FancyObject_p _false;


/**
 * Runtime initialization functions.
 */
void init_core_classes()
{
  ObjectClass = new Class();

  ClassClass = new Class(ObjectClass);
  ClassClass->set_class(ClassClass);

  ModuleClass = new Class(ObjectClass);
  ModuleClass->set_class(ModuleClass);

  NilClass = new Class(ObjectClass);
  TClass = new Class(ObjectClass);
  FalseClass = new Class(ObjectClass);
  StringClass = new Class(ObjectClass);
  SymbolClass = new Class(ObjectClass);
  NumberClass = new Class(ObjectClass);
  RegexClass = new Class(ObjectClass);
  ArrayClass = new Class(ObjectClass);
  MethodClass = new Class(ObjectClass);
  MethodCallClass = new Class(ObjectClass); 
  
  ConsoleClass = new Class(ObjectClass); 
}

void init_global_objects()
{
  nil = new FancyObject(NilClass, new Nil());
  t = new FancyObject(TClass, new T());
  _false = new FancyObject(FalseClass, new Nil());
}

void init_global_scope()
{
  // the global scope has ObjectClass as its current_self value
  // -> every global method call is a methodcall on ObjectClass
  global_scope = new Scope(ObjectClass);

  /* define classes */
  global_scope->define("Class", ClassClass);
  global_scope->define("Module", ModuleClass);
  global_scope->define("Object", ObjectClass);
  global_scope->define("NilClass", NilClass);
  global_scope->define("TrueClass", TClass);
  global_scope->define("FalseClass", FalseClass);
  global_scope->define("String", StringClass);
  global_scope->define("Symbol", SymbolClass);
  global_scope->define("Number", NumberClass);
  global_scope->define("Regex", RegexClass);
  global_scope->define("Array", ArrayClass);
  global_scope->define("Method", MethodClass);
  global_scope->define("MethodCall", MethodClass);

  global_scope->define("Console", ConsoleClass);
  
  /* define singleton objects */
  global_scope->define("nil", nil);
  global_scope->define("true", t);
  global_scope->define("false", _false);
}
