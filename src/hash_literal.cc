#include "includes.h"

HashLiteral::HashLiteral(key_val_node *key_val_list) :
  NativeObject(OBJ_HASHLITERAL)
{
  for(key_val_node *tmp = key_val_list; tmp != NULL; tmp = tmp->next) {
    this->_key_val_list.push_back(pair<Expression_p, Expression_p>(tmp->key, tmp->val));
  }
}

HashLiteral::HashLiteral(list< pair<Expression_p, Expression_p> > key_val_list) :
  NativeObject(OBJ_HASHLITERAL),
  _key_val_list(key_val_list)
{
}

HashLiteral::~HashLiteral()
{
}

NativeObject_p HashLiteral::equal(const NativeObject_p other) const
{
  return nil;
}

FancyObject_p HashLiteral::eval(Scope *scope)
{
  map<FancyObject_p, FancyObject_p> mappings;
  list< pair<Expression_p, Expression_p> >::iterator it;
  for(it = _key_val_list.begin(); it != _key_val_list.end(); it++) {
    mappings[it->first->eval(scope)] = it->second->eval(scope);
  }
  return HashClass->create_instance(new Hash(mappings));
}

string HashLiteral::to_s() const
{
  return "<HashLiteral>";
}
