#ifndef _BOOTSTRAP_METHOD_H_
#define _BOOTSTRAP_METHOD_H_

namespace fancy {
  namespace bootstrap {
    
    void init_method_class();

    /**
     * Method instance methods
     */
    FancyObject_p method_Method_docstring(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

  }
}

#endif /* _BOOTSTRAP_METHOD_H_ */
