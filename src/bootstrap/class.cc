#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_class_class()
    {
      /**
       * Class instance methods
       */
      DEF_METHOD(ClassClass,
                 "define_method:with:",
                 "Define a method on a Class, taking a Block as the \
second argument to serve as the method's body.",
                 define_method__with);

      DEF_METHOD(ClassClass,
                 "define_class_method:with:",
                 "Define a class method, taking a Block as the \
second argument to serve as the method's body.",
                 define_class_method__with);

      DEF_METHOD(ClassClass,
                 "include:",
                 "Include another Class into this one (to serve as a mix-in).",
                 include);

      DEF_METHOD(ClassClass,
                 "method:",
                 "Returns the Method object with a given name (or nil, if method not defined).",
                 method);
    }


    /**
     * Class instance methods
     */

    METHOD(ClassClass, define_method__with)
    {
      EXPECT_ARGS("Class#define_method:with:", 2);
      FancyObject_p arg1 = args[0];
      FancyObject_p arg2 = args[1];
      if(Block_p method_block = dynamic_cast<Block_p>(arg2)) {
        method_block->override_self(true);
        dynamic_cast<Class_p>(self)->def_method(arg1->to_s(), method_block);
        return t;
      } else {
        errorln("Class#define_method:with: expects String and Block arguments.");
        return nil;
      }
    }

    METHOD(ClassClass, define_class_method__with)
    {
      EXPECT_ARGS("Class#define_class_method:with:", 2);
      FancyObject_p arg1 = args[0];
      FancyObject_p arg2 = args[1];

      if(IS_BLOCK(arg2)) {
        dynamic_cast<Class_p>(self)->def_class_method(arg1->to_s(),
                                                      dynamic_cast<Block_p>(arg2));
        return t;
      } else {
        errorln("Class#define_class_method:with: expects String and Block arguments.");
        return nil;
      }
    }

    METHOD(ClassClass, include)
    {
      EXPECT_ARGS("Class#include:", 1);

      if(Class_p the_klass = dynamic_cast<Class_p>(args[0])) {
        dynamic_cast<Class_p>(self)->include(the_klass);
        return t;
      } else {
        errorln("Class#include: expects Class argument.");
        return nil;
      }
    }

    METHOD(ClassClass, method)
    {
      EXPECT_ARGS("Class#method:", 1);

      if(Class_p the_klass = dynamic_cast<Class_p>(self)) {
        if(Method_p meth = dynamic_cast<Method_p>(the_klass->find_method(args[0]->to_s()))) {
          return meth;
        }
        if(NativeMethod_p native_meth = dynamic_cast<NativeMethod_p>(the_klass->find_method(args[0]->to_s()))) {
          return native_meth;
        }
      }
      return nil;
    }

  }
}
