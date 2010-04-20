#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_class_class()
    {
      ClassClass->def_method("define_method:with:", new NativeMethod("define_method:with:", method_Class_define_method__with, 2));
      ClassClass->def_method("define_class_method:with:", new NativeMethod("define_method:with:", method_Class_define_class_method__with, 2));
      ClassClass->def_method("include:", new NativeMethod("include:", method_Class_include, 1));
      ClassClass->def_method("method:", new NativeMethod("method:", method_Class_method, 1));
    }


    /**
     * Class instance methods
     */

    FancyObject_p method_Class_define_method__with(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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

    FancyObject_p method_Class_define_class_method__with(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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

    FancyObject_p method_Class_include(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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

    FancyObject_p method_Class_method(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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
