#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include "hash_literal.h"
#include "../../hash.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      HashLiteral::HashLiteral(key_val_node *key_val_list)
      {
        for(key_val_node *tmp = key_val_list; tmp != NULL; tmp = tmp->next) {
          _key_val_list.push_back(pair<Expression*, Expression*>(tmp->key, tmp->val));
        }
      }

      FancyObject* HashLiteral::eval(Scope *scope)
      {
        map<FancyObject*, FancyObject*> mappings;
        list< pair<Expression*, Expression*> >::iterator it;
        for(it = _key_val_list.begin(); it != _key_val_list.end(); it++) {
          mappings[it->first->eval(scope)] = it->second->eval(scope);
        }
        return new Hash(mappings);
      }

      string HashLiteral::to_sexp() const
      {
        stringstream s;

        s << "[:hash_lit, ";

        int size = _key_val_list.size();
        int count = 1;
        list< pair<Expression*, Expression*> >::const_iterator it;
        for(it = _key_val_list.begin(); it != _key_val_list.end(); it++) {
          s << "[" << it->first->to_sexp() << ", ";
          s << it->second->to_sexp() << "]";

          if(count < size) {
            s << ", ";
          }

          count++;
        }

        s << "]";

        return s.str();
      }

    }
  }
}
