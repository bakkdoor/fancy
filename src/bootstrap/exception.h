#ifndef _BOOTSTRAP_EXCEPTION_H_
#define _BOOTSTRAP_EXCEPTION_H_

namespace fancy {
  namespace bootstrap {
    
    void init_exception_classes();

    /**
     * Exception class methods
     */
    FancyObject_p class_method_Exception_new(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

    /**
     * Exception instance methods
     */
    FancyObject_p method_Exception_raise(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Exception_message(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

    /**
     * MethodNotFoundError instance methods
     */
    FancyObject_p method_MethodNotFoundError_method_name(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_MethodNotFoundError_class(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

    /**
     * IOError instance methods
     */
    FancyObject_p method_IOError_filename(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_IOError_modes(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

  }
}

#endif /* _BOOTSTRAP_EXCEPTION_H_ */
