#ifndef _NATIVE_METHOD_H_
#define _NATIVE_METHOD_H_

namespace fancy {

  /**
   * This file contains the definition of the scope structure and its
   * functions. A scope defines an environment in which identifiers &
   * functions are stored for evaluation purposes.
   */

  class NativeMethod : public FancyObject, public Callable
  {
  public:
    NativeMethod(string identifier,
                 FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *scope),
                 unsigned int n_args,
                 bool special);

    NativeMethod(string identifier,
                 FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *scope),
                 unsigned int n_args);

    NativeMethod(string identifier,
                 FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *scope));

    ~NativeMethod();

    virtual FancyObject_p eval(Scope *scope);
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;
    virtual FancyObject_p call(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
  
    string _identifier;
    FancyObject_p (&_func)(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
    unsigned int _n_args;
    bool _special;
  };

  typedef NativeMethod* NativeMethod_p;

}

#endif /* _NATIVE_METHOD_H_ */
