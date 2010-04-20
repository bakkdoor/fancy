#ifndef _FUNCTION_H_
#define _FUNCTION_H_

namespace fancy {

  struct method_arg_node {
  public:
    Identifier_p name;
    Identifier_p identifier;
    method_arg_node *next;
  };

  class Method : public FancyObject, public Callable
  {
  public:
    Method(Identifier_p op_name, Identifier_p op_argname, const ExpressionList_p body);
    Method(const list< pair<Identifier_p, Identifier_p> > argnames, const ExpressionList_p body);
    Method(const list< pair<Identifier_p, Identifier_p> > argnames, const ExpressionList_p body, bool special);
    ~Method();

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;
    virtual FancyObject_p call(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
    virtual FancyObject_p call(FancyObject_p self, Scope *scope);

    unsigned int argcount() const;
    list< pair<Identifier_p, Identifier_p> > argnames() const;

  protected:
    string method_ident();
    void init_docstring();
    list< pair<Identifier_p, Identifier_p> > _argnames;
    ExpressionList_p _body;
    bool _special; /* used for 'special' functions (like macros) */
    bool _is_operator;
  };

  typedef Method* Method_p;

}

#endif /* _FUNCTION_H_ */
