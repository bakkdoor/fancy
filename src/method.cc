#include "includes.h"

namespace fancy {

  Method::Method(Identifier_p op_name, Identifier_p op_argname, const ExpressionList_p body) :
    FancyObject(MethodClass),
    _body(body),
    _special(false),
    _is_operator(true)
  {
    _argnames.push_back(pair<Identifier_p, Identifier_p>(op_name, op_argname));
    init_docstring();
  }

  Method::Method(const list< pair<Identifier_p, Identifier_p> > argnames,
                 const ExpressionList_p body) : 
    FancyObject(MethodClass),
    _argnames(argnames),
    _body(body),
    _special(false),
    _is_operator(false)
  {
    init_docstring();
  }

  Method::Method(const list< pair<Identifier_p, Identifier_p> >  argnames,
                 const ExpressionList_p body,
                 bool special) :
    FancyObject(MethodClass),
    _argnames(argnames),
    _body(body),
    _special(special),
    _is_operator(false)
  {
    init_docstring();
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

  FancyObject_p Method::equal(const FancyObject_p other) const
  {
    // can't compare methods with anything else
    return nil;
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
        // name_it->second holds the name of the actual param name 
        // (the first is part of the method name)
        call_scope->define(name_it->second->name(), (*arg_it));
        name_it++;
        arg_it++;
      }
    
      // finally, eval the methods body expression
      return this->_body->eval(call_scope);
    }
  
    return nil;
  }

  OBJ_TYPE Method::type() const
  {
    return OBJ_METHOD;
  }

  string Method::to_s() const
  {
    return "<method>";
  }

  string Method::method_ident()
  {
    stringstream str;
    list< pair<Identifier_p, Identifier_p> >::iterator it;
    for(it = _argnames.begin(); it != _argnames.end(); it++) {
      str << it->first->name();
      if(!_is_operator) {
        str << ":";
      }
    }

    return str.str();
  }


  void Method::init_docstring()
  {
    this->_docstring = "[DOC] " + this->method_ident() + "\n\t" + this->_body->docstring();
  }

}
