#ifndef _PARSER_NODES_SELF_H_
#define _PARSER_NODES_SELF_H_

#include "identifier.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      class Self : public Identifier
      {
      public:
        static Self* node();
      private:
        Self();
        virtual ~Self() {}

        virtual FancyObject* eval(Scope *scope);
        virtual EXP_TYPE type() const;

        static Self* _self_node;
      };

    }
  }
}


#endif /* _PARSER_NODES_SELF_H_ */
