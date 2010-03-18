#include "includes.h"

Block::Block(ExpressionList_p body) :
  NativeObject(OBJ_BLOCK),
  _body(body),
  _block_fancy_obj(0),
  _creation_scope(0)
{
  init_fancy_obj_cache();
}

Block::Block(list<Identifier_p> argnames, ExpressionList_p body) :
  NativeObject(OBJ_BLOCK),
  _argnames(argnames),
  _body(body),
  _block_fancy_obj(0),
  _creation_scope(0)
{
  init_fancy_obj_cache();
}

Block::~Block()
{
}

FancyObject_p Block::eval(Scope *scope)
{
  if(!this->_creation_scope) {
    set_creation_scope(scope);
  }

  if(this->_block_fancy_obj) {
    return this->_block_fancy_obj;
  } else {
    init_fancy_obj_cache();
    return this->_block_fancy_obj;
  }
}

NativeObject_p Block::equal(const NativeObject_p other) const
{
  return nil;
}

string Block::to_s() const
{
  return "<Block>";
}

FancyObject_p Block::call(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
{
  if(!this->_creation_scope) {
    set_creation_scope(scope);
  }

  // vector with temporary values for block parameter names (original values)
  vector<FancyObject_p> old_values(args.size());

  if(args.size() > 0) {
    list<Identifier_p>::iterator name_it = _argnames.begin();
    list<FancyObject_p>::iterator args_it = args.begin();
    int i = 0;
    while(name_it != _argnames.end() && args_it != args.end()) {
      string name = (*name_it)->name();
      // save old value for name in old_values
      old_values[i] = _creation_scope->get(name);
      // set new value (argument)
      _creation_scope->define(name, (*args_it));
      name_it++;
      args_it++;
      i++;
    }
  }
  
  // finally, eval the blocks body expression
  FancyObject_p return_value = this->_body->eval(_creation_scope);
  
  // reset old values for param names in creation_scope (if any args given)
  if(args.size() > 0) {
    list<Identifier_p>::iterator name_it = _argnames.begin();
    unsigned int i = 0;
    while(name_it != _argnames.end() && i < args.size()) {
      string name = (*name_it)->name();
      _creation_scope->define(name, old_values[i]);
      i++;
      name_it++;
    }
  }

  return return_value;
}

void Block::init_fancy_obj_cache()
{
  this->_block_fancy_obj = BlockClass->create_instance(this);
}

void Block::set_creation_scope(Scope *creation_scope)
{
  this->_creation_scope = creation_scope;
}
