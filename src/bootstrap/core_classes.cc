#include "includes.h"

/**
 * Core Classes
 */
Class_p ClassClass = 0;
Class_p ModuleClass;
Class_p ObjectClass;
Class_p NilClass;
Class_p TrueClass;
Class_p StringClass;
Class_p SymbolClass;
Class_p NumberClass;
Class_p RegexClass;
Class_p ArrayClass;
Class_p HashClass;
Class_p MethodClass;
Class_p MethodCallClass;
Class_p BlockClass;
Class_p FileClass;
Class_p ConsoleClass;

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
  ObjectClass = new Class("Object");

  ClassClass = new Class("Class", ObjectClass);
  ClassClass->set_class(ClassClass);
  ObjectClass->set_class(ClassClass);

  ModuleClass = new Class("Module", ObjectClass);
  ModuleClass->set_class(ModuleClass);

  NilClass = new Class("NilClass", ObjectClass);
  TrueClass = new Class("TrueClass", ObjectClass);
  StringClass = new Class("String", ObjectClass);
  SymbolClass = new Class("Symbol", ObjectClass);
  NumberClass = new Class("Number", ObjectClass);
  RegexClass = new Class("Regex", ObjectClass);
  ArrayClass = new Class("Array", ObjectClass);
  HashClass = new Class("Hash", ObjectClass);
  MethodClass = new Class("Method", ObjectClass);
  MethodCallClass = new Class("MethodCall", ObjectClass);
  BlockClass = new Class("Block", ObjectClass);
  FileClass = new Class("File", ObjectClass);
  ConsoleClass = new Class("Console", ObjectClass);

  init_object_class();
  init_block_class();
  init_string_class();
  init_number_class();
  init_console_class();
  init_nil_class();
}

void init_global_objects()
{
  nil = new FancyObject(NilClass, new Nil());
  t = new FancyObject(TrueClass, new True());
}

void init_global_scope()
{
  // the global scope has an instance of ObjectClass as its
  // current_self value
  // -> every global method call is a methodcall on ObjectClass
  global_scope = new Scope(ObjectClass->create_instance());

  /* define classes */
  global_scope->define("Class", ClassClass);
  global_scope->define("Module", ModuleClass);
  global_scope->define("Object", ObjectClass);
  global_scope->define("NilClass", NilClass);
  global_scope->define("TrueClass", TrueClass);
  global_scope->define("String", StringClass);
  global_scope->define("Symbol", SymbolClass);
  global_scope->define("Number", NumberClass);
  global_scope->define("Regex", RegexClass);
  global_scope->define("Array", ArrayClass);
  global_scope->define("Hash", HashClass);
  global_scope->define("Method", MethodClass);
  global_scope->define("MethodCall", MethodClass);
  global_scope->define("Block", BlockClass);
  global_scope->define("File", FileClass);
  global_scope->define("Console", ConsoleClass);
  
  /* define singleton objects */
  global_scope->define("nil", nil);
  global_scope->define("true", t);
}
