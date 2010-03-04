#ifndef _FUNCTION_H_
#define _FUNCTION_H_

struct method_arg_node {
public:
  Identifier_p name;
  Identifier_p identifier;
  method_arg_node *next;
};

class Method : public NativeObject
{
 public:
  Method(const list< pair<Identifier_p, Identifier_p> > argnames, const Expression_p body);
  Method(const list< pair<Identifier_p, Identifier_p> > argnames, const Expression_p body, bool special);
  ~Method();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual NativeObject_p eval(Scope *scope);
  virtual string to_s() const;

  unsigned int argcount() const;
  list< pair<Identifier_p, Identifier_p> > argnames() const;

 protected:
  list< pair<Identifier_p, Identifier_p> > _argnames;
  Expression_p body;
  bool special; /* used for 'special' functions (like macros) */
};

typedef Method* Method_p;

#endif /* _FUNCTION_H_ */
