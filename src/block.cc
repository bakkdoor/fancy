#include "includes.h"

Block::Block(ExpressionList_p body) :
  NativeObject(OBJ_BLOCK),
  _body(body),
  _block_fancy_obj(0)
{
  init_fancy_obj_cache();
}

Block::Block(list<Identifier_p> argnames, ExpressionList_p body) :
  NativeObject(OBJ_BLOCK),
  _argnames(argnames),
  _body(body),
  _block_fancy_obj(0)
{
  init_fancy_obj_cache();
}

Block::~Block()
{
}

FancyObject_p Block::eval(Scope *scope)
{
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

FancyObject_p Block::call(FancyObject_p self, list<Expression_p> args, Scope *scope)
{
  // TODO: call the block
  // warnln("Can't call Blocks yet!");

  Scope *call_scope = new Scope(self, scope);

  if(args.size() > 0) {
    NativeObject_p first_arg = args.front()->eval(scope)->native_value();
    if(IS_ARRAY(first_arg)) {
      Array_p args_array = dynamic_cast<Array_p>(first_arg);

      // eval, so all the values within array are evaluated.
      args_array->eval(scope);

      // check amount of given arguments
      if(_argnames.size() != args_array->size()) {
        error("Given amount of arguments (")
          << args_array->size()
          << ") doesn't match expected amount ("
          << _argnames.size()
          << ") for block";
        return nil;
      }

      // if amount ok, set the parameters to the given arguments
      list<Identifier_p>::iterator name_it = _argnames.begin();
      int i = 0;
      int arr_size = args_array->size();

      while(name_it != _argnames.end() && i < arr_size) {
        FancyObject_p argval = args_array->at(i)->eval(scope);
        // name_it->second holds the name of the actual param name
        // (the first is part of the method name)
        call_scope->define((*name_it)->name(), argval);
        name_it++;
        i++;
      }
    } else {
      errorln("Block#call: expects Array as argument. Got something else!");
      return nil;
    }
  }

  // finally, eval the blocks body expression
  return this->_body->eval(call_scope);
}

void Block::init_fancy_obj_cache()
{
  this->_block_fancy_obj = BlockClass->create_instance(this);
}
