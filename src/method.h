#ifndef _FUNCTION_H_
#define _FUNCTION_H_

struct method_arg_node {
public:
  Identifier_p name;
  Identifier_p identifier;
  method_arg_node *next;
};

class Method : public Object
{
 public:
  Method(const Array_p argnames, const Expression_p body);
  Method(const Array_p argnames, const Expression_p body, bool special);
  ~Method();

  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;

  unsigned int argcount() const;
  vector<string> argnames() const;

 protected:
  void init_argnames(const Array_p argnames);
  vector<string> _argnames;
  Expression_p body;
  bool special; /* used for 'special' functions (like macros) */
};

typedef Method* Method_p;

#endif /* _FUNCTION_H_ */
