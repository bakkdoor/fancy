#ifndef _BLOCK_LITERAL_H_
#define _BLOCK_LITERAL_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      struct block_arg_node {
      public:
        Identifier *argname;
        block_arg_node *next;
      };

      /**
       * BlockLiteral class used in the parser for literal Block values.
       * When evaluated, returns an instance of BlockClass.
       */
      class BlockLiteral : public Expression
      {
      public:
        BlockLiteral(ExpressionList_p body);
        BlockLiteral(list<Identifier_p> argnames, ExpressionList_p body);
        BlockLiteral(block_arg_node *argnames, ExpressionList_p body);
        virtual ~BlockLiteral();

        virtual FancyObject_p eval(Scope *scope);
        virtual OBJ_TYPE type() const;

      private:
        list<Identifier_p> _argnames;
        ExpressionList_p _body;
      };

    }
  }
}

#endif /* _BLOCK_LITERAL_H_ */
