#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      HashLiteral::HashLiteral(key_val_node *key_val_list)
      {
        for(key_val_node *tmp = key_val_list; tmp != NULL; tmp = tmp->next) {
          _key_val_list.push_back(pair<Expression_p, Expression_p>(tmp->key, tmp->val));
        }
      }

      HashLiteral::~HashLiteral()
      {
      }

      FancyObject_p HashLiteral::eval(Scope *scope)
      {
        map<FancyObject_p, FancyObject_p> mappings;
        list< pair<Expression_p, Expression_p> >::iterator it;
        for(it = _key_val_list.begin(); it != _key_val_list.end(); it++) {
          mappings[it->first->eval(scope)] = it->second->eval(scope);
        }
        return new Hash(mappings);
      }

      EXP_TYPE HashLiteral::type() const
      {
        return EXP_HASHLITERAL;
      }

    }
  }
}
