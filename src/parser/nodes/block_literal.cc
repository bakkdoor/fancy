#include "includes.h"

BlockLiteral::BlockLiteral(ExpressionList_p body) :
  NativeObject(),
  _body(body)
{
}

BlockLiteral::BlockLiteral(list<Identifier_p> argnames, ExpressionList_p body) :
  NativeObject(),
  _argnames(argnames),
  _body(body)
{
}

BlockLiteral::~BlockLiteral()
{
}

FancyObject_p BlockLiteral::eval(Scope *scope)
{
  Block_p block = new Block(_argnames, _body, scope);
  return BlockClass->create_instance(block);
}

NativeObject_p BlockLiteral::equal(const NativeObject_p other) const
{
  return nil;
}

OBJ_TYPE BlockLiteral::type() const
{
  return OBJ_BLOCKLITERAL;
}

string BlockLiteral::to_s() const
{
  return "<BlockLiteral>";
}

