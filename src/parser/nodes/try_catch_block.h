#ifndef _PARSER_NODES_TRY_CATCH_BLOCK_H_
#define _PARSER_NODES_TRY_CATCH_BLOCK_H_

namespace fancy {
  namespace parser {
    namespace nodes {

      class ExceptionHandler;

      struct except_handler_list {
        ExceptionHandler *handler;
        except_handler_list *next;
      };

      class ExceptionHandler : public gc_cleanup
      {
      public:
        ExceptionHandler(Identifier_p exception_class_name, Identifier_p local_name, Expression_p body);
        ~ExceptionHandler();

        bool can_handle(Class_p the_class, Scope *scope);
        FancyObject_p handle(FancyException_p exception, Scope *scope);

      private:
        Identifier_p _exception_class_name;
        Class_p _exception_class;
        Identifier_p _local_name;
        Expression_p _body;
      };

      class TryCatchBlock : public Expression
      {
      public:
        TryCatchBlock(ExpressionList_p body, except_handler_list *except_handlers);
        TryCatchBlock(ExpressionList_p body, list<ExceptionHandler*> except_handlers);
        virtual ~TryCatchBlock();

        virtual EXP_TYPE type() const;
        virtual FancyObject_p eval(Scope *scope);

      private:
        ExpressionList_p _body;
        list<ExceptionHandler*> _except_handlers;
      };

    }
  }
}

#endif /* _PARSER_NODES_TRY_RESCUE_BLOCK_H_ */
