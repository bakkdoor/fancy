#include "includes.h"

Class_p ConsoleClass;

void init_console_class()
{
  NativeMethod_p print_method =
    new NativeMethod("print:", class_method_Console_print, 1, false);
  ConsoleClass->define_native_class_method(print_method); 

  NativeMethod_p println_method =
    new NativeMethod("println:", class_method_Console_println, 1, false);
  ConsoleClass->define_native_class_method(println_method); 
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

