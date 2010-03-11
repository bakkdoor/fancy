#include "includes.h"

#include "includes.h"

void init_string_class()
{  
  // ConsoleClass->def_native_method(new NativeMethod("downcase", method_String_downcase)); 
  // ConsoleClass->def_native_method(new NativeMethod("upcase", method_String_upcase)); 
}


/**
 * String instance methods
 */

FancyObject_p method_String_downcase(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  if(args.size() > 0) {
    cerr << "Console#print got more than 0 arguments!" << endl;
  } else {
    if(IS_STRING(self->native_value())) {
      string str = dynamic_cast<String_p>(self->native_value())->value();
      
      // transform (str.begin(), str.end(),    // source
      //            str.begin(),             // destination
      //            toupper);              // operation

      cout << "uppered:  " << str << endl;

      return StringClass->create_instance(String::from_value(str));
    } else {
      return nil;
    }
  }
  return nil;
}

FancyObject_p method_String_downcase(list<Expression_p> args, Scope *scope)
{
  if(args.size() > 0) {
    cerr << "Console#println got more than 0 arguments!" << endl;
  } else {
    FancyObject_p arg = args.front()->eval(scope);
    cout << arg->to_s() << endl;
  }
  return nil;
}


