#ifndef _BOOTSTRAP_CLASS_H_
#define _BOOTSTRAP_CLASS_H_

namespace fancy {
  namespace bootstrap {

    void init_class_class();

    /**
     * Class instance methods
     */
    FancyObject_p method_Class_define_method__with(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
    FancyObject_p method_Class_define_class_method__with(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
    FancyObject_p method_Class_include(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

  }
}

#endif /* _BOOTSTRAP_CLASS_H_ */
