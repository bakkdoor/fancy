#include "includes.h"

void init_console_class()
{
  ConsoleClass->def_class_method("print:", new NativeMethod("print:", class_method_Console_print, 1)); 
  ConsoleClass->def_class_method("println:", new NativeMethod("println:", class_method_Console_println, 1)); 
}


/**
 * Console class methods
 */

FancyObject_p class_method_Console_print(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  FancyObject_p arg = args.front()->eval(scope);
  cout << arg->to_s();
  return nil;
}

FancyObject_p class_method_Console_println(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  FancyObject_p arg = args.front()->eval(scope);
  cout << arg->to_s() << endl;
  return nil;
}

