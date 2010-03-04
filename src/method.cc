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
  cout << endl << endl <<"eval method!"<<endl <<endl;
  return this->body->eval(scope);
}

string Method::to_s() const
{
  return "<method>";
}
