#include "includes.h"

namespace fancy {

  Block::Block(ExpressionList_p body, Scope *creation_scope) :
    FancyObject(BlockClass),
    _body(body),
    _creation_scope(creation_scope),
    _override_self(false),
    _argcount(0)
  {
    this->_docstring = "<BLOCK>";
  }

  Block::Block(list<Identifier_p> argnames, ExpressionList_p body, Scope *creation_scope) :
    FancyObject(BlockClass),
    _argnames(argnames),
    _body(body),
    _creation_scope(creation_scope),
    _override_self(false)
  {
    this->_docstring = "<BLOCK>";
    this->_argcount = argnames.size();
  }

  Block::~Block()
  {
  }

  FancyObject_p Block::equal(const FancyObject_p other) const
  {
    return nil;
  }

  OBJ_TYPE Block::type() const
  {
    return OBJ_BLOCK;
  }

  string Block::to_s() const
  {
    return "<Block>";
  }

  FancyObject_p Block::call(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
  {
    // check if block is empty
    if(this->_body->size() == 0)
      return nil;

    // array with temporary values for block parameter names (original values)
    FancyObject_p *old_values = new FancyObject_p[argc];

    if(argc > 0) {
      list<Identifier_p>::iterator name_it = _argnames.begin();
      int i = 0;
      while(name_it != _argnames.end() && i < argc) {
        string name = (*name_it)->name();
        // save old value for name in old_values
        old_values[i] = _creation_scope->get(name);
        // set new value (argument)
        _creation_scope->define(name, args[i]);
        name_it++;
        i++;
      }
    }

    FancyObject_p return_value = this->call(self, scope);

    // reset old values for param names in creation_scope (if any args given)
    if(argc > 0) {
      list<Identifier_p>::iterator name_it = _argnames.begin();
      int i = 0;
      while(name_it != _argnames.end() && i < argc) {
        string name = (*name_it)->name();
        _creation_scope->define(name, old_values[i]);
        i++;
        name_it++;
      }
    }

    // delete old_values array
    delete[] old_values;

    return return_value;
  }

  FancyObject_p Block::call(FancyObject_p self, Scope *scope)
  {
    // check if block is empty
    if(this->_body->size() == 0) {
      return nil;
    }

    FancyObject_p old_self = _creation_scope->current_self();
    if(_override_self) {
      _creation_scope->set_current_self(self);
    }

    // finally, eval the blocks body expression
    FancyObject_p return_value = this->_body->eval(_creation_scope);

    // restore old self if _override_self
    if(_override_self) {
      _creation_scope->set_current_self(old_self);
    }
  
    return return_value;
  }

  void Block::set_creation_scope(Scope *creation_scope)
  {
    this->_creation_scope = creation_scope;
  }

  Scope* Block::creation_scope() const
  {
    return this->_creation_scope;
  }

  vector<FancyObject_p> Block::args()
  {
    vector<FancyObject_p> args(_argnames.size(), nil);
    int i = 0;
    for(list<Identifier_p>::iterator it = _argnames.begin();
        it != _argnames.end();
        it++) {
      args[i] = Symbol::from_string(":" + (*it)->name());
      i++;
    }
    return args;
  }

  unsigned int Block::argcount() const
  {
    return _argcount;
  }

  void Block::override_self(bool do_it)
  {
    _override_self = do_it;
  }

  bool Block::is_empty() const
  {
    return this->_body->size() == 0;
  }
}
