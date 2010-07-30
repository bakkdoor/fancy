#include "../../vendor/gc/include/gc.h"
#include "../../vendor/gc/include/gc_cpp.h"
#include "../../vendor/gc/include/gc_allocator.h"

#include "includes.h"

#include "../block.h"
#include "../parser/nodes/class_definition.h"


namespace fancy {
  namespace bootstrap {

    void init_class_class()
    {

      /**
       * Class class methods.
       */
      DEF_CLASSMETHOD(ClassClass,
                      "superclass:body:",
                      "Creates a new Class with a given superclass and a Block defining its body.",
                      superclass__body);

      /**
       * Class instance methods
       */

      DEF_METHOD(ClassClass,
                 "define_method:with:",
                 "Define a method on a Class, taking a Block as the \
second argument to serve as the method's body.",
                 define_method__with);

      DEF_METHOD(ClassClass,
                 "undefine_method:",
                 "Undefine an existing method on a Class.",
                 undefine_method);

      DEF_METHOD(ClassClass,
                 "define_class_method:with:",
                 "Define a class method, taking a Block as the \
second argument to serve as the method's body.",
                 define_class_method__with);

      DEF_METHOD(ClassClass,
                 "undefine_class_method:",
                 "Undefine an existing class method on a Class.",
                 undefine_class_method);

      DEF_METHOD(ClassClass,
                 "include:",
                 "Include another Class into this one (to serve as a mix-in).",
                 include);

      DEF_METHOD(ClassClass,
                 "method:",
                 "Returns the Method object with a given name (or nil, if method not defined).",
                 method);

      DEF_METHOD(ClassClass,
                 "superclass",
                 "Returns the Class' superclass.",
                 superclass);

      DEF_METHOD(ClassClass,
                 "subclass:",
                 "Creates a new subclass for this class with a given body.",
                 subclass);

      DEF_METHOD(ClassClass,
                 "nested_classes",
                 "Returns an Array of all the nested classes within a Class.",
                 nested_classes);
    }

    /**
     * Class class methods.
     */

    CLASSMETHOD(ClassClass, superclass__body)
    {
      EXPECT_ARGS("Class#superclass:body:", 2);
      if(Class* superclass = dynamic_cast<Class*>(args[0])) {
        if(Block* body_block = dynamic_cast<Block*>(args[1])) {
          parser::nodes::ClassDefExpr* class_def = new parser::nodes::ClassDefExpr(superclass, Identifier::from_string("AnonymousClass"), body_block->body());
          FancyObject* new_class_obj = class_def->eval(scope);
          return new_class_obj;
        } else {
          errorln("No Block given to Class##superclass:body:");
          return nil;
        }
      } else {
        errorln("No valid Superclass given to Class##superclass:body:");
        return nil;
      }
    }

    /**
     * Class instance methods
     */

    METHOD(ClassClass, define_method__with)
    {
      EXPECT_ARGS("Class#define_method:with:", 2);
      FancyObject* arg1 = args[0];
      FancyObject* arg2 = args[1];
      if(Block* method_block = dynamic_cast<Block*>(arg2)) {
        method_block->override_self(true);
        dynamic_cast<Class*>(self)->def_method(arg1->to_s(), method_block);
        return t;
      } else {
        errorln("Class#define_method:with: expects String and Block arguments.");
        return nil;
      }
    }

    METHOD(ClassClass, undefine_method)
    {
      EXPECT_ARGS("Class#undefine_method:", 1);
      string method_name = args[0]->to_s();
      Class* the_class = dynamic_cast<Class*>(self);
      if(the_class->undef_method(method_name)) {
        return t; // return t if method was defined, nil otherwise.
      } else {
        return nil;
      }
    }

    METHOD(ClassClass, define_class_method__with)
    {
      EXPECT_ARGS("Class#define_class_method:with:", 2);
      FancyObject* arg1 = args[0];
      FancyObject* arg2 = args[1];

      if(IS_BLOCK(arg2)) {
        dynamic_cast<Class*>(self)->def_class_method(arg1->to_s(),
                                                      dynamic_cast<Block*>(arg2));
        return t;
      } else {
        errorln("Class#define_class_method:with: expects String and Block arguments.");
        return nil;
      }
    }

    METHOD(ClassClass, undefine_class_method)
    {
      EXPECT_ARGS("Class#undefine_class_method:", 1);
      string method_name = args[0]->to_s();
      Class* the_class = dynamic_cast<Class*>(self);
      if(the_class->undef_class_method(method_name)) {
        return t; // return t if method was defined, nil otherwise.
      } else {
        return nil;
      }
    }

    METHOD(ClassClass, include)
    {
      EXPECT_ARGS("Class#include:", 1);

      if(Class* the_klass = dynamic_cast<Class*>(args[0])) {
        dynamic_cast<Class*>(self)->include(the_klass);
        return t;
      } else {
        errorln("Class#include: expects Class argument.");
        return nil;
      }
    }

    METHOD(ClassClass, method)
    {
      EXPECT_ARGS("Class#method:", 1);

      if(Class* the_klass = dynamic_cast<Class*>(self)) {
        if(Method* meth = dynamic_cast<Method*>(the_klass->find_method(args[0]->to_s()))) {
          return meth;
        }
        if(NativeMethod* native_meth = dynamic_cast<NativeMethod*>(the_klass->find_method(args[0]->to_s()))) {
          return native_meth;
        }
      }
      return nil;
    }

    METHOD(ClassClass, superclass)
    {
      if(Class* superclass =  dynamic_cast<Class*>(self)->superclass()) {
        return superclass;
      } else {
        return nil;
      }
    }

    METHOD(ClassClass, subclass)
    {
      EXPECT_ARGS("Class#subclass:", 1);
      if(Class* superclass = dynamic_cast<Class*>(self)) {
        if(Block* body_block = dynamic_cast<Block*>(args[0])) {
          parser::nodes::ClassDefExpr* class_def = new parser::nodes::ClassDefExpr(superclass, Identifier::from_string("AnonymousClass"), body_block->body());
          FancyObject* new_class_obj = class_def->eval(scope);
          return new_class_obj;
        } else {
          errorln("No Block given to Class#subclass:");
          return nil;
        }
      } else {
        errorln("Self is not a valid Superclass in Class#subclass:");
        return nil;
      }
    }

    METHOD(ClassClass, nested_classes)
    {
      return new Array(dynamic_cast<Class*>(self)->nested_classes());
    }

  }
}

