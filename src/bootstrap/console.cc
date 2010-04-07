#include "includes.h"

void init_console_class()
{
  ConsoleClass->def_class_method("print:", new NativeMethod("print:", class_method_Console_print, 1)); 
  ConsoleClass->def_class_method("println:", new NativeMethod("println:", class_method_Console_println, 1)); 
  ConsoleClass->def_class_method("readln", new NativeMethod("readln", class_method_Console_readln)); 
}


/**
 * Console class methods
 */

FancyObject_p class_method_Console_print(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  EXPECT_ARGS("Console##print:", 1);
  cout << args.front()->to_s();
  return nil;
}

FancyObject_p class_method_Console_println(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  EXPECT_ARGS("Console##println:", 1);
  cout << args.front()->to_s() << "\n";
  return nil;
}

FancyObject_p class_method_Console_readln(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  string input;
  getline(cin, input);
  return String::from_value(input);
}

