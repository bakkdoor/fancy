#include "includes.h"

void init_console_class()
{
  ConsoleClass->def_native_class_method(new NativeMethod("print:", class_method_Console_print, 1)); 
  ConsoleClass->def_native_class_method(new NativeMethod("println:", class_method_Console_println, 1)); 
}


/**
 * Console class methods
 */

FancyObject_p class_method_Console_print(list<Expression_p> args, Scope *scope)
{
  if(args.size() > 1) {
    cerr << "Console#print got more than 1 argument!" << endl;
  } else {
    FancyObject_p arg = args.front()->eval(scope);
    cout << arg->to_s();
  }
  return nil;
}

FancyObject_p class_method_Console_println(list<Expression_p> args, Scope *scope)
{
  if(args.size() > 1) {
    cerr << "Console#println got more than 1 argument!" << endl;
  } else {
    FancyObject_p arg = args.front()->eval(scope);
    cout << arg->to_s() << endl;
  }
  return nil;
}

