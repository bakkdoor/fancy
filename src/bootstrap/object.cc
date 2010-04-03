#include "includes.h"

void init_object_class()
{  
  ObjectClass->def_class_method("new", new NativeMethod("new", class_method_Object_new));
  ObjectClass->def_class_method("new:", new NativeMethod("new", class_method_Object_new_with_arg));

  ObjectClass->def_method("and:", new NativeMethod("and:", method_Object_and));
  ObjectClass->def_method("or:", new NativeMethod("or:", method_Object_or));
  ObjectClass->def_method("not", new NativeMethod("not", method_Object_not));
  
  ObjectClass->def_method("to_s", new NativeMethod("to_s", method_Object_to_s));
  ObjectClass->def_method("inspect", new NativeMethod("inspect", method_Object_inspect));

  ObjectClass->def_method("_class", new NativeMethod("_class", method_Object_class));
  ObjectClass->def_method("define_singleton_method:with:", new NativeMethod("define_singleton_method:with:", method_Object_define_singleton_method__with, 2));

  ObjectClass->def_method("==", new NativeMethod("==", method_Object_eq));
  ObjectClass->def_method("is_a?:", new NativeMethod("is_a?:", method_Object_is_a, 1));
}

/**
 * Object class methods
 */

FancyObject_p class_method_Object_new(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(IS_CLASS(self)) {
    Class_p the_class = dynamic_cast<Class_p>(self);
    FancyObject_p new_instance = the_class->create_instance();
    if(new_instance->responds_to("initialize")) {
      new_instance->call_method("initialize", args, scope);
    }
    return new_instance;
  } else {
    errorln("Expected instance to be a class. Not the case!");
  }
  return nil;
}

FancyObject_p class_method_Object_new_with_arg(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(IS_CLASS(self)) {
    Class_p the_class = dynamic_cast<Class_p>(self);
    FancyObject_p new_instance = the_class->create_instance();
    if(new_instance->responds_to("initialize:")) {
      new_instance->call_method("initialize:", args, scope);
    }
    return new_instance;
  } else {
    errorln("Expected instance to be a class. Not the case!");
  }
  return nil;
}

FancyObject_p method_Object_and(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(self != nil && args.front() != nil) {
    return t;
  } else {
    return nil;
  }
}

FancyObject_p method_Object_or(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(self != nil || args.front() != nil) {
    return t;
  } else {
    return nil;
  }
}

FancyObject_p method_Object_not(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(self == nil) {
    return t;
  } else {
    return nil;
  }
}

FancyObject_p method_Object_to_s(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  return String::from_value(self->to_s());
}

FancyObject_p method_Object_inspect(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  return String::from_value(self->to_s() + " : " + self->get_class()->name());
}

FancyObject_p method_Object_class(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  return self->get_class();
}

FancyObject_p method_Object_define_singleton_method__with(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  FancyObject_p arg1 = args.front();
  args.pop_front();
  FancyObject_p arg2 = args.front();

  if(IS_STRING(arg1) && IS_BLOCK(arg2)) {
    self->def_singleton_method(dynamic_cast<String_p>(arg1)->value(), dynamic_cast<Block_p>(arg2));
    return t;
  } else {
    errorln("Object#define_singleton_method:with: expects String and Block arguments.");
    return nil;
  }
}

FancyObject_p method_Object_eq(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(self->equal(args.front()))
    return t;
  return nil;
}

FancyObject_p method_Object_is_a(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  Class_p the_class = dynamic_cast<Class_p>(args.front());
  if(the_class) {
    if(self->get_class() == the_class)
      return t;
  } else {
    errorln("Object#is_a?: expects Class argument.");
  }
  return nil;
}
