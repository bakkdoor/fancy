#ifndef _PARSER_NODES_TRY_CATCH_BLOCK_H_
#define _PARSER_NODES_TRY_CATCH_BLOCK_H_

#include "../../expression.h"
#include "../../class.h"
#include "../../fancy_exception.h"
#include "expression_list.h"
#include "identifier.h"

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
        ExceptionHandler(Identifier* exception_class_name, Identifier* local_name, Expression* body);
        ~ExceptionHandler() {}

        bool can_handle(Class* the_class, Scope *scope);
        FancyObject* handle(FancyObject* exception, Scope *scope);

        Identifier* exception_class_name() const { return _exception_class_name; }
        Identifier* local_name() const { return _local_name; }
        Expression* body() const { return _body; }

      private:
        Identifier* _exception_class_name;
        Class* _exception_class;
        Identifier* _local_name;
        Expression* _body;
      };

      class TryCatchBlock : public Expression
      {
      public:
        TryCatchBlock(ExpressionList* body, except_handler_list* except_handlers);
        TryCatchBlock(ExpressionList* body, except_handler_list* except_handlers, ExpressionList* finally_block);
        TryCatchBlock(ExpressionList* body, list<ExceptionHandler*> except_handlers);
        TryCatchBlock(ExpressionList* body, list<ExceptionHandler*> except_handlers, ExpressionList* finally_block);
        virtual ~TryCatchBlock() {}

        virtual EXP_TYPE type() const { return EXP_TRYCATCHBLOCK; }
        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;

      private:
        void init_except_handlers(except_handler_list* except_handlers);
        ExpressionList* _body;
        list<ExceptionHandler*> _except_handlers;
        ExpressionList* _finally_block;
      };

    }
  }
}

#endif /* _PARSER_NODES_TRY_RESCUE_BLOCK_H_ */
