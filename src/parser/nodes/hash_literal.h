#ifndef _HASH_LITERAL_H_
#define _HASH_LITERAL_H_

#include <list>

#include "../../expression.h"
#include "expression_list.h"
#include "identifier.h"

using namespace std;

namespace fancy {
  namespace parser {
    namespace nodes {

      struct key_val_node {
      public:
        Expression* key;
        Expression* val;
        key_val_node *next;
      };

      class HashLiteral : public Expression
      {
      public:
        HashLiteral(key_val_node *key_val_list);
        virtual ~HashLiteral() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const { return EXP_HASHLITERAL; }

      private:
        list< pair<Expression*, Expression*> > _key_val_list;
      };

    }
  }
}

#endif /* _HASH_LITERAL_H_ */
