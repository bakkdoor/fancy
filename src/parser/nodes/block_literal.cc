#include "includes.h"

BlockLiteral::BlockLiteral(ExpressionList_p body) :
  _body(body)
{
}

BlockLiteral::BlockLiteral(list<Identifier_p> argnames, ExpressionList_p body) :
  _argnames(argnames),
  _body(body)
{
}

BlockLiteral::BlockLiteral(block_arg_node *argnames, ExpressionList_p body) :
  _body(body)
{
  for(block_arg_node *tmp = argnames; tmp != NULL; tmp = tmp->next) {
    _argnames.push_front(tmp->argname);
  }
}

BlockLiteral::~BlockLiteral()
{
}

FancyObject_p BlockLiteral::eval(Scope *scope)
{
  return new Block(_argnames, _body, scope);
}

OBJ_TYPE BlockLiteral::type() const
{
  return OBJ_BLOCKLITERAL;
}

