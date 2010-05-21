#include "includes.h"

namespace fancy {

  Method::Method(Identifier_p op_name, Identifier_p op_argname, const ExpressionList_p body) :
    FancyObject(MethodClass),
    _body(body),
    _is_operator(true)
  {
    _argnames.push_back(pair<Identifier_p, Identifier_p>(op_name, op_argname));
    init_method_ident();
    init_docstring();
  }

  Method::Method(const list< pair<Identifier_p, Identifier_p> > argnames,
                 const ExpressionList_p body) : 
    FancyObject(MethodClass),
    _argnames(argnames),
    _body(body),
    _is_operator(false)
  {
    init_method_ident();
    init_docstring();
  }

  Method::Method() :
    FancyObject(MethodClass),
    _is_operator(false)
  {
  }

  Method::~Method()
  {
  }

  unsigned int Method::argcount() const
  {
    return _argnames.size();
  }

  list< pair<Identifier_p, Identifier_p> > Method::argnames() const
  {
    return _argnames;
  }

  FancyObject_p Method::equal(const FancyObject_p other) const
  {
    // can't compare methods with anything else
    return nil;
  }

  FancyObject_p Method::call(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
  {
    // check if method is empty
    if(_body->size() == 0)
      return nil;

    Scope *call_scope = new Scope(self, scope);

    // check amount of given arguments
    if(_argnames.size() != (unsigned int)argc) {
      error("Given amount of arguments (")
        << argc
        << ") doesn't match expected amount ("
        << _argnames.size()
        << ")";
    } else {
      // if amount ok, set the parameters to the given arguments
      list< pair<Identifier_p, Identifier_p> >::iterator name_it = _argnames.begin();
      // list<FancyObject_p>::iterator arg_it = args.begin();
      int i = 0;
    
      while(name_it != _argnames.end() && i < argc) {
        // name_it->second holds the name of the actual param name 
        // (the first is part of the method name)
        call_scope->define(name_it->second->name(), args[i]);
        name_it++;
        i++;
      }
    
      // finally, eval the methods body expression
      return _body->eval(call_scope);
    }
  
    return nil;
  }

  FancyObject_p Method::call(FancyObject_p self, Scope *scope)
  {
    // check if method is empty
    if(_body->size() == 0)
      return nil;

    Scope *call_scope = new Scope(self, scope);
    return _body->eval(call_scope);
  }

  OBJ_TYPE Method::type() const
  {
    return OBJ_METHOD;
  }

  string Method::to_s() const
  {
    return "<Method : '" + _method_ident + "' Doc:'" + _docstring + "'>";
  }

  void Method::init_method_ident()
  {
    stringstream str;
    list< pair<Identifier_p, Identifier_p> >::iterator it;
    for(it = _argnames.begin(); it != _argnames.end(); it++) {
      str << it->first->name();
      if(!_is_operator) {
        str << ":";
      }
    }
    _method_ident = str.str();
  }


  void Method::init_docstring()
  {
    _docstring = _body->docstring();
  }

  string Method::name() const
  {
    return _method_ident;
  }

  void Method::set_name(const string &method_name)
  {
    _method_ident = method_name;
  }

}
