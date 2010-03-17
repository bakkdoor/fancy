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

FancyObject_p Method::call(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  Scope *call_scope = new Scope(self, scope);

  // check amount of given arguments
  if(_argnames.size() != args.size()) {
    error("Given amount of arguments (")
      << args.size()
      << ") doesn't match expected amount ("
      << _argnames.size()
      << ")";
  } else {
    // if amount ok, set the parameters to the given arguments
    list< pair<Identifier_p, Identifier_p> >::iterator name_it = _argnames.begin();
    list<FancyObject_p>::iterator arg_it = args.begin();
    
    while(name_it != _argnames.end() && arg_it != args.end()) {
      FancyObject_p argval = (*arg_it)->eval(scope);
      // name_it->second holds the name of the actual param name 
      // (the first is part of the method name)
      call_scope->define(name_it->second->name(), argval);
      name_it++;
      arg_it++;
    }
    
    // finally, eval the methods body expression
    return this->body->eval(call_scope);
  }
  
  return nil;
}

string Method::to_s() const
{
  return "<method>";
}
