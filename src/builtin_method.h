#ifndef _BUILTIN_METHOD_H_
#define _BUILTIN_METHOD_H_

/**
 * This file contains the definition of the scope structure and its
 * functions. A scope defines an environment in which identifiers &
 * functions are stored for evaluation purposes.
 */

class BuiltinMethod : public Object
{
 public:
  BuiltinMethod(string identifier,
                  Object_p (&func)(Object_p args, Scope *scope),
                  unsigned int n_args,
                  bool special);
  ~BuiltinMethod();

  virtual Object_p eval(Scope *scope);
  virtual Object_p equal(const Object_p other) const;
  virtual string to_s() const;
  
  string _identifier;
  Object_p (&_func)(Object_p args, Scope *scope);
  unsigned int _n_args;
  bool _special;
  Object_p arg_expressions;
};

typedef BuiltinMethod* BuiltinMethod_p;


#endif /* _BUILTIN_METHOD_H_ */
