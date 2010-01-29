#include "includes.h"

Method::Method(const Array_p argnames,
               const Expression_p body) : 
  Object(OBJ_METHOD), body(body), special(false)
{
  init_argnames(argnames);
}

Method::Method(const Array_p argnames,
                   const Expression_p body,
                   bool special) :
  Object(OBJ_METHOD), body(body), special(special)
{
  init_argnames(argnames);
}

Method::~Method()
{
}

unsigned int Method::argcount() const
{
  return this->_argnames.size();
}

vector<string> Method::argnames() const
{
  return this->_argnames;
}

Object_p Method::equal(const Object_p other) const
{
  // can't compare methods with anything else
  return nil;
}

Object_p Method::eval(Scope *scope)
{
  cout << endl << endl <<"eval method!"<<endl <<endl;
  return this->body->eval(scope);
}

string Method::to_s() const
{
  return "<method>";
}

void Method::init_argnames(const Array_p argnames)
{
  for(int i = 0; i < argnames->size(); i++) {
    assert(IS_IDENT(argnames->at(i)));
    Identifier_p ident = (Identifier_p)argnames->at(i);
    this->_argnames.push_back(ident->name());
  }
}
