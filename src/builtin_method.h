#ifndef _BUILTIN_METHOD_H_
#define _BUILTIN_METHOD_H_

/**
 * This file contains the definition of the scope structure and its
 * functions. A scope defines an environment in which identifiers &
 * functions are stored for evaluation purposes.
 */

class BuiltinMethod : public NativeObject
{
 public:
  BuiltinMethod(string identifier,
                FancyObject_p (&func)(FancyObject_p args, Scope *scope),
                unsigned int n_args,
                bool special);
  ~BuiltinMethod();

  virtual FancyObject_p eval(Scope *scope);
  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual string to_s() const;
  
  string _identifier;
  FancyObject_p (&_func)(FancyObject_p args, Scope *scope);
  unsigned int _n_args;
  bool _special;
  NativeObject_p arg_expressions;
};

typedef BuiltinMethod* BuiltinMethod_p;


#endif /* _BUILTIN_METHOD_H_ */
