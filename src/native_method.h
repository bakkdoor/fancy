#ifndef _NATIVE_METHOD_H_
#define _NATIVE_METHOD_H_

#include "method.h"

namespace fancy {

  /**
   * NativeMethod class representing native methods defined for Fancy.
   */
  class NativeMethod : public Method
  {
  public:
    /**
     * NativeMethod constructor.
     * @param identifier Name of the NativeMethod.
     * @param func C++ function pointer that contains the code for the methods body.
     */
    NativeMethod(string identifier,
                 FancyObject* (&func)(FancyObject* self, FancyObject* *args, int argc, Scope *scope));

    /**
     * NativeMethod constructor.
     * @param identifier Name of the NativeMethod.
     * @param docstring Documentation string for NativeMethod.
     * @param func C++ function pointer that contains the code for the methods body.
     */
    NativeMethod(string identifier,
                 string docstring,
                 FancyObject* (&func)(FancyObject* self, FancyObject* *args, int argc, Scope *scope));

    ~NativeMethod() {}

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject* equal(FancyObject* other) const;
    virtual EXP_TYPE type() const { return EXP_NATIVEMETHOD; }
    virtual string to_s() const;

    /**
     * Inherited from Callable. Calls the NativeMethod.
     * @param self The self object, also known as the receiver of the method.
     * @param args C++ Array of FancyObjects that are the arguments for this method.
     * @param args Amount of arguments passed to this method.
     * @param scope Scope in which the method should be evaluated.
     * @return Return value of the method call.
     */
    virtual FancyObject* call(FancyObject* self, FancyObject* *args, int argc, Scope *scope);

    /**
     * Inherited from Callable. Calls the NativeMethod without any arguments.
     * @param self The self object, also known as the receiver of the method.
     * @param scope Scope in which the method should be evaluated.
     * @return Return value of the method call.
     */
    virtual FancyObject* call(FancyObject* self, Scope *scope);

    /**
     * Returns the identifier (name) of the NativeMethod.
     * @return Identifier (name) of the NativeMethod.
     */
    string identifier() const { return _identifier; }
  
  private:
    string _identifier;

    /**
     * The C++ function pointer for the NativeMethod's body code.
     */
    FancyObject* (&_func)(FancyObject* self, FancyObject* *args, int argc, Scope *scope);
  };

}

#endif /* _NATIVE_METHOD_H_ */
