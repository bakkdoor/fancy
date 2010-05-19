#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Object class methods
     */
    METHOD(Object_class__new);
    METHOD(Object_class__new_with_arg);

    /**
     * Object instance methods
     */
    METHOD(Object__and);
    METHOD(Object__or);
    METHOD(Object__not);
    METHOD(Object__to_s);
    METHOD(Object__inspect);
    METHOD(Object__class);
    METHOD(Object__define_singleton_method__with);
    METHOD(Object__eq);
    METHOD(Object__is_a);
    METHOD(Object__send);
    METHOD(Object__send__params);
    METHOD(Object__responds_to);
    METHOD(Object__get_slot);
    METHOD(Object__set_slot__with);
    METHOD(Object__docstring_set);
    METHOD(Object__docstring_get);
    METHOD(Object__methods);

    void init_object_class()
    {  
      ObjectClass->def_class_method("new",
                                    new NativeMethod("new",
                                                     "New method for creating new instances of classes.\
It is expected, that self (the receiver) is a class object.",
                                                     Object_class__new));

      ObjectClass->def_class_method("new:",
                                    new NativeMethod("new",
                                                     "Same as Object#new, but also expecting arguments\
and passing them on to the initialize: method of the class.",
                                                     Object_class__new_with_arg));

      ObjectClass->def_method("and:",
                              new NativeMethod("and:",
                                               "Boolean conjunction.",
                                               Object__and));

      ObjectClass->def_method("or:",
                              new NativeMethod("or:",
                                               "Boolean disjunction.",
                                               Object__or));

      ObjectClass->def_method("not",
                              new NativeMethod("not",
                                               "Boolean negation. In Fancy, everything non-nil is logically true.",
                                               Object__not));
  
      ObjectClass->def_method("to_s",
                              new NativeMethod("to_s",
                                               "Returns string representation of object.",
                                               Object__to_s));

      ObjectClass->def_method("inspect",
                              new NativeMethod("inspect",
                                               "Returns detailed string representation of object.",
                                               Object__inspect));

      ObjectClass->def_method("_class",
                              new NativeMethod("_class",
                                               "Returns the class of the object.",
                                               Object__class));

      ObjectClass->def_method("define_singleton_method:with:",
                              new NativeMethod("define_singleton_method:with:",
                                               "Defines singleton method on object.",
                                               Object__define_singleton_method__with));

      ObjectClass->def_method("==",
                              new NativeMethod("==",
                                               "Índicates, if two objects are equal.",
                                               Object__eq));

      ObjectClass->def_method("is_a?:",
                              new NativeMethod("is_a?:",
                                               "Indicates, if an object is an instance of a given Class.",
                                               Object__is_a));

      ObjectClass->def_method("send:",
                              new NativeMethod("send:",
                                               "Sends a message to an object with no arguments.",
                                               Object__send));

      ObjectClass->def_method("send:params:",
                              new NativeMethod("send:params:",
                                               "Sends a message to an object with an Array of arguments.",
                                               Object__send__params));

      ObjectClass->def_method("responds_to?:",
                              new NativeMethod("responds_to?:",
                                               "Indicates, if an object responds to a given method name.",
                                               Object__responds_to));

      ObjectClass->def_method("get_slot:",
                              new NativeMethod("get_slot:",
                                               "Returns the value of slot.",
                                               Object__get_slot));

      ObjectClass->def_method("set_slot:with:",
                              new NativeMethod("set_slot:with:",
                                               "Sets the value of slot.",
                                               Object__set_slot__with));

      ObjectClass->def_method("docstring:",
                              new NativeMethod("docstring:",
                                               "Sets the docstring for an object.",
                                               Object__docstring_set));
      ObjectClass->def_method("docstring",
                              new NativeMethod("docstring",
                                               "Returns the docstring for an object.",
                                               Object__docstring_get));

      ObjectClass->def_method("methods",
                              new NativeMethod("methods",
                                               "Returns all methods of an object in an Array.",
                                               Object__methods));
    }

    /**
     * Object class methods
     */

    METHOD(Object_class__new)
    {
      if(IS_CLASS(self)) {
        Class_p the_class = dynamic_cast<Class_p>(self);
        FancyObject_p new_instance = the_class->create_instance();
        if(new_instance->responds_to("initialize")) {
          new_instance->call_method("initialize", args, argc, scope);
        }
        return new_instance;
      } else {
        errorln("Expected instance to be a class. Not the case!");
      }
      return nil;
    }

    METHOD(Object_class__new_with_arg)
    {
      EXPECT_ARGS("Object##new:", 1);
      if(IS_CLASS(self)) {
        Class_p the_class = dynamic_cast<Class_p>(self);
        FancyObject_p new_instance = the_class->create_instance();
        if(new_instance->responds_to("initialize:")) {
          new_instance->call_method("initialize:", args, argc, scope);
        }
        return new_instance;
      } else {
        errorln("Expected instance to be a class. Not the case!");
      }
      return nil;
    }

    /**
     * Object instance methods
     */

    METHOD(Object__and)
    {
      EXPECT_ARGS("Object#and:", 1);
      if(self != nil && args[0] != nil) {
        return t;
      } else {
        return nil;
      }
    }

    METHOD(Object__or)
    {
      EXPECT_ARGS("Object#or:", 1);
      if(self != nil || args[0] != nil) {
        return t;
      } else {
        return nil;
      }
    }

    METHOD(Object__not)
    {
      if(self == nil) {
        return t;
      } else {
        return nil;
      }
    }

    METHOD(Object__to_s)
    {
      return String::from_value(self->to_s());
    }

    METHOD(Object__inspect)
    {
      return String::from_value(self->inspect() + " : " + self->get_class()->name());
    }

    METHOD(Object__class)
    {
      return self->get_class();
    }

    METHOD(Object__define_singleton_method__with)
    {
      EXPECT_ARGS("Object#define_singleton_method:with:", 2);
      FancyObject_p arg1 = args[0];
      FancyObject_p arg2 = args[1];

      if(IS_STRING(arg1) && IS_BLOCK(arg2)) {
        self->def_singleton_method(dynamic_cast<String_p>(arg1)->value(), dynamic_cast<Block_p>(arg2));
        return t;
      } else {
        errorln("Object#define_singleton_method:with: expects String and Block arguments.");
        return nil;
      }
    }

    METHOD(Object__eq)
    {
      EXPECT_ARGS("Object#==", 1);
      return self->equal(args[0]);
    }

    METHOD(Object__is_a)
    {
      EXPECT_ARGS("Object#is_a?:", 1);
      Class_p the_class = dynamic_cast<Class_p>(args[0]);
      if(the_class) {
        if(self->get_class() == the_class)
          return t;
      } else {
        errorln("Object#is_a?: expects Class argument.");
      }
      return nil;
    }

    METHOD(Object__send)
    {
      EXPECT_ARGS("Object#send:", 1);
      string method_name = args[0]->to_s();
      return self->call_method(method_name, 0, 0, scope);
    }

    METHOD(Object__send__params)
    {
      EXPECT_ARGS("Object#send:params:", 2);
      string method_name = args[0]->to_s();
      if(Array_p arr = dynamic_cast<Array_p>(args[1])) {
        int size = arr->size();
        FancyObject_p *arg_array = new FancyObject_p[size];
        for(int i = 0; i < size; i++) {
          arg_array[i] = arr->at(i);
        }
        FancyObject_p retval = self->call_method(method_name, arg_array, size, scope);
        delete[] arg_array; // cleanup
        return retval;
      } else {
        errorln("Object#send:params: expects Array as second argument.");
      }
      return nil;
    }

    METHOD(Object__responds_to)
    {
      EXPECT_ARGS("Object#responds_to?:", 1);
      string method_name = args[0]->to_s();
      if(self->responds_to(method_name)) {
        return t;
      }
      return nil;
    }

    METHOD(Object__get_slot)
    {
      EXPECT_ARGS("Object#get_slot:", 1);
      string slot_name = "@" + args[0]->to_s();
      FancyObject_p slot = self->get_slot(slot_name);
      return slot;
    }

    METHOD(Object__set_slot__with)
    {
      EXPECT_ARGS("Object#set_slot:with:", 2);
      string slot_name = "@" + args[0]->to_s();
      FancyObject_p value = args[1];
      self->set_slot(slot_name, value);
      return self;
    }

    METHOD(Object__docstring_set)
    {
      EXPECT_ARGS("Object#docstring:", 1);
      self->set_docstring(args[0]->to_s());
      return t;
    }

    METHOD(Object__docstring_get)
    {
      return String::from_value(self->docstring());
    }

    METHOD(Object__methods)
    {
      return self->methods();
    }
  }
}
