#include "includes.h"

#include "includes.h"

void init_string_class()
{  
  StringClass->def_native_method(new NativeMethod("downcase", method_String_downcase));
  StringClass->def_native_method(new NativeMethod("upcase", method_String_upcase));
}


/**
 * String instance methods
 */

FancyObject_p method_String_downcase(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  if(args.size() > 0) {
    cerr << "String#downcase got more than 0 arguments!" << endl;
  } else {
    if(IS_STRING(self->native_value())) {
      string str = dynamic_cast<String_p>(self->native_value())->value();
      std::transform(str.begin(), str.end(), str.begin(), ::tolower);
      return StringClass->create_instance(String::from_value(str));
    } else {
      return nil;
    }
  }
  return nil;
}

FancyObject_p method_String_upcase(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  if(args.size() > 0) {
    cerr << "String#upcase got more than 0 arguments!" << endl;
  } else {
    if(IS_STRING(self->native_value())) {
      string str = dynamic_cast<String_p>(self->native_value())->value();
      std::transform(str.begin(), str.end(), str.begin(), ::toupper);
      return StringClass->create_instance(String::from_value(str));
    } else {
      return nil;
    }
  }
  return nil;
}


