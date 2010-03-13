#include "includes.h"

Method::Method(const list< pair<Identifier_p, Identifier_p> > argnames,
               const Expression_p body) : 
  NativeObject(OBJ_METHOD), _argnames(argnames), body(body), special(false)
{
}

Method::Method(const list< pair<Identifier_p, Identifier_p> >  argnames,
               const Expression_p body,
               bool special) :
  NativeObject(OBJ_METHOD), _argnames(argnames), body(body), special(special)
{
}

Method::~Method()
{
}

unsigned int Method::argcount() const
{
  return this->_argnames.size();
}

list< pair<Identifier_p, Identifier_p> > Method::argnames() const
{
  return this->_argnames;
}

NativeObject_p Method::equal(const NativeObject_p other) const
{
  // can't compare methods with anything else
  return nil;
}

FancyObject_p Method::eval(Scope *scope)
{
  cout << endl << endl << "eval method!" << endl <<endl;
  return MethodClass->create_instance(this);
}

FancyObject_p Method::call(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  cout << "calling method!" << endl;
  return nil;
}

string Method::to_s() const
{
  return "<method>";
}
