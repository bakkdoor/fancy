#include "includes.h"

namespace fancy {

  /**
   * Core Classes
   */
  Class_p ClassClass = 0;
  Class_p ObjectClass;
  Class_p NilClass;
  Class_p TrueClass;
  Class_p StringClass;
  Class_p SymbolClass;
  Class_p NumberClass;
  Class_p RegexpClass;
  Class_p ArrayClass;
  Class_p HashClass;
  Class_p MethodClass;
  Class_p MethodCallClass;
  Class_p BlockClass;
  Class_p FileClass;
  Class_p DirectoryClass;
  Class_p ConsoleClass;
  Class_p ScopeClass;

  Class_p ExceptionClass;
  Class_p UnknownIdentifierErrorClass;
  Class_p MethodNotFoundErrorClass;
  Class_p IOErrorClass;

  Class_p SystemClass;

  /**
   * Global Singleton Objects
   */
  FancyObject_p nil;
  FancyObject_p t;

  namespace bootstrap {

    /**
     * Runtime initialization functions.
     */
    void init_core_classes()
    {
      ObjectClass = new Class("Object");

      ClassClass = new Class("Class", ObjectClass);
      ClassClass->set_class(ClassClass);
      ObjectClass->set_class(ClassClass);

      NilClass = new Class("NilClass", ObjectClass);
      TrueClass = new Class("TrueClass", ObjectClass);
      StringClass = new Class("String", ObjectClass);
      SymbolClass = new Class("Symbol", ObjectClass);
      NumberClass = new Class("Number", ObjectClass);
      RegexpClass = new Class("Regexp", ObjectClass);
      ArrayClass = new Class("Array", ObjectClass);
      HashClass = new Class("Hash", ObjectClass);
      MethodClass = new Class("Method", ObjectClass);
      MethodCallClass = new Class("MethodCall", ObjectClass);
      BlockClass = new Class("Block", ObjectClass);
      FileClass = new Class("File", ObjectClass);
      DirectoryClass = new Class("Directory", ObjectClass);
      ConsoleClass = new Class("Console", ObjectClass);
      ScopeClass = new Class("Scope", ObjectClass);

      ExceptionClass = new Class("Exception", ObjectClass);
      UnknownIdentifierErrorClass = new Class("UnknownIdentifierError", ExceptionClass);
      MethodNotFoundErrorClass = new Class("MethodNotFoundError", ExceptionClass);
      IOErrorClass = new Class("IOError", ExceptionClass);

      SystemClass = new Class("System", ObjectClass);

      init_object_class();
      init_class_class();
      init_block_class();
      init_string_class();
      init_number_class();
      init_console_class();
      init_array_class();
      init_file_class();
      init_directory_class();
      init_scope_class();
      init_hash_class();
      init_exception_classes();
      init_method_class();
      init_system_class();
    }

    void init_global_objects()
    {
      nil = new Nil();
      t = new True();
    }

    void init_global_scope()
    {
      // the global scope has an instance of ObjectClass as its
      // current_self value
      // -> every global method call is a methodcall on ObjectClass
      global_scope = new Scope(ObjectClass->create_instance());

      /* define classes */
      global_scope->define("Class", ClassClass);
      global_scope->define("Object", ObjectClass);
      global_scope->define("NilClass", NilClass);
      global_scope->define("TrueClass", TrueClass);
      global_scope->define("String", StringClass);
      global_scope->define("Symbol", SymbolClass);
      global_scope->define("Number", NumberClass);
      global_scope->define("Regexp", RegexpClass);
      global_scope->define("Array", ArrayClass);
      global_scope->define("Hash", HashClass);
      global_scope->define("Method", MethodClass);
      global_scope->define("MethodCall", MethodClass);
      global_scope->define("Block", BlockClass);
      global_scope->define("File", FileClass);
      global_scope->define("Directory", DirectoryClass);
      global_scope->define("Console", ConsoleClass);
      global_scope->define("Scope", ScopeClass);

      global_scope->define("Exception", ExceptionClass);
      global_scope->define("UnknownIdentifierError", UnknownIdentifierErrorClass);
      global_scope->define("MethodNotFoundError", MethodNotFoundErrorClass);
      global_scope->define("IOError", IOErrorClass);

      global_scope->define("System", SystemClass);
  
      /* define singleton objects */
      global_scope->define("nil", nil);
      global_scope->define("true", t);
    }

  }
}
