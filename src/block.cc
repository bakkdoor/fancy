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

FancyObject_p Block::call(list<Expression_p> args, Scope *scope)
{
  // TODO: call the block
  warnln("Can't call Blocks yet!");
  return nil;
}

void Block::init_fancy_obj_cache()
{
  this->_block_fancy_obj = BlockClass->create_instance(this);
}
