#include "includes.h"

void init_object_class()
{  
  ObjectClass->def_class_method("new", new NativeMethod("new", class_method_Object_new));
  ObjectClass->def_class_method("new:", new NativeMethod("new", class_method_Object_new_with_arg));
}

/**
 * Object class methods
 */

FancyObject_p class_method_Object_new(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(self->is_class()) {
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
  if(self->is_class()) {
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
