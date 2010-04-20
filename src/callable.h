#ifndef _CALLABLE_H_
#define _CALLABLE_H_

namespace fancy {

  class Scope;
  class FancyObject;
  class Expression;

  /**
   * Interface for callable objects.
   * (Native methods, user-defined methods & blocks ...)
   */
  class Callable
  {
  public:
    /**
     * Calls the Callable and returns the return value of the call.
     * @param self The self value within the call (the FancyObject on
     * which the Callable is called).
     * @param args List of arguments to the call.
     * @param scope The calling scope.
     */
    virtual FancyObject* call(FancyObject *self, FancyObject** args, int argc, Scope *scope) = 0;

    /**
     * Calls the Callable (with no arguments) and returns the return
     * value of the call.
     * @param self The self value within the call (the FancyObject on
     * which the Callable is called).
     * @param scope The calling scope.
     */
    virtual FancyObject* call(FancyObject *self, Scope *scope) = 0;
  };

  typedef Callable* Callable_p;

}

#endif /* _CALLABLE_H_ */
