#ifndef _NATIVE_METHOD_H_
#define _NATIVE_METHOD_H_

namespace fancy {

  /**
   * NativeMethod class representing native methods defined for Fancy.
   */
  class NativeMethod : public FancyObject, public Callable
  {
  public:
    /**
     * NativeMethod constructor.
     * @param identifier Name of the NativeMethod.
     * @param func C++ function pointer that contains the code for the methods body.
     */
    NativeMethod(string identifier,
                 FancyObject_p (&func)(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope));

    ~NativeMethod();

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject_p eval(Scope *scope);
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;

    /**
     * Inherited from Callable. Calls the NativeMethod.
     * @param self The self object, also known as the receiver of the method.
     * @param args C++ Array of FancyObjects that are the arguments for this method.
     * @param args Amount of arguments passed to this method.
     * @param scope Scope in which the method should be evaluated.
     * @return Return value of the method call.
     */
    virtual FancyObject_p call(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

    /**
     * Inherited from Callable. Calls the NativeMethod without any arguments.
     * @param self The self object, also known as the receiver of the method.
     * @param scope Scope in which the method should be evaluated.
     * @return Return value of the method call.
     */
    virtual FancyObject_p call(FancyObject_p self, Scope *scope);
  
    /**
     * The identifier (name) of the NativeMethod.
     */
    string _identifier;

    /**
     * The C++ function pointer for the NativeMethod's body code.
     */
    FancyObject_p (&_func)(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
  };

  typedef NativeMethod* NativeMethod_p;

}

#endif /* _NATIVE_METHOD_H_ */
