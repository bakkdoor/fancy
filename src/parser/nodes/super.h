#ifndef _PARSER_NODES_SUPER_H_
#define _PARSER_NODES_SUPER_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      class Super : public Expression
      {
      public:
        Super();
        virtual ~Super();

        virtual FancyObject_p eval(Scope *scope);
        virtual OBJ_TYPE type() const;
      };

    }
  }
}

#endif /* _PARSER_NODES_SUPER_H_ */
