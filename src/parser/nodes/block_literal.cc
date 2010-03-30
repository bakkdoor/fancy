#include "includes.h"

BlockLiteral::BlockLiteral(ExpressionList_p body) :
  NativeObject(OBJ_BLOCKLITERAL),
  _body(body)
{
}

BlockLiteral::BlockLiteral(list<Identifier_p> argnames, ExpressionList_p body) :
  NativeObject(OBJ_BLOCKLITERAL),
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

string BlockLiteral::to_s() const
{
  return "<BlockLiteral>";
}

