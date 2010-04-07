#include "includes.h"

void init_class_class()
{
  ClassClass->def_method("define_method:with:", new NativeMethod("define_method:with:", method_Class_define_method__with, 2));
  ClassClass->def_method("define_class_method:with:", new NativeMethod("define_method:with:", method_Class_define_class_method__with, 2));
  ClassClass->def_method("include:", new NativeMethod("include:", method_Class_include, 1));
}


/**
 * Class instance methods
 */

FancyObject_p method_Class_define_method__with(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  EXPECT_ARGS("Class#define_method:with:", 2);
  FancyObject_p arg1 = args.front();
  args.pop_front();
  FancyObject_p arg2 = args.front();

  if(IS_STRING(arg1) && IS_BLOCK(arg2)) {
    dynamic_cast<Class_p>(self)->def_method(dynamic_cast<String_p>(arg1)->value(), 
                                            dynamic_cast<Block_p>(arg2));
    return t;
  } else {
    errorln("Class#define_method:with: expects String and Block arguments.");
    return nil;
  }
}

FancyObject_p method_Class_define_class_method__with(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  EXPECT_ARGS("Class#define_class_method:with:", 2);
  FancyObject_p arg1 = args.front();
  args.pop_front();
  FancyObject_p arg2 = args.front();

  if(IS_STRING(arg1) && IS_BLOCK(arg2)) {
    dynamic_cast<Class_p>(self)->def_class_method(dynamic_cast<String_p>(arg1)->value(),
                                                  dynamic_cast<Block_p>(arg2));
    return t;
  } else {
    errorln("Class#define_class_method:with: expects String and Block arguments.");
    return nil;
  }
}

FancyObject_p method_Class_include(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  EXPECT_ARGS("Class#include:", 1);

  if(Class_p the_klass = dynamic_cast<Class_p>(args.front())) {
    dynamic_cast<Class_p>(self)->include(the_klass);
    return t;
  } else {
    errorln("Class#include: expects Class argument.");
    return nil;
  }
}
