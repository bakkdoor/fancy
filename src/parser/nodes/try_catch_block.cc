#include "try_catch_block.h"
#include "../../scope.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      // ExceptionHandler
      
      ExceptionHandler::ExceptionHandler(Identifier* exception_class_name,
                                         Identifier* local_name,
                                         Expression* body) :
        _exception_class_name(exception_class_name),
        _exception_class(0),
        _local_name(local_name),
        _body(body)
      {
      }

      ExceptionHandler::~ExceptionHandler()
      {
      }

      bool ExceptionHandler::can_handle(Class* the_class, Scope *scope)
      {
        _exception_class = dynamic_cast<Class*>(scope->get(_exception_class_name->name()));
        if(_exception_class)
          return _exception_class->subclass_of(the_class);
        return false;
      }

      FancyObject* ExceptionHandler::handle(FancyException* exception, Scope *scope)
      {
        Scope *catch_scope = new Scope(scope);
        if(_local_name->name() != "") {
          scope->define(_local_name->name(), exception);
        }
        return _body->eval(catch_scope);
      }

      // TryCatchBlock

      TryCatchBlock::TryCatchBlock(ExpressionList* body,
                                     except_handler_list *except_handlers) :
        _body(body)
      {
        for(except_handler_list *tmp = except_handlers; tmp != NULL; tmp = tmp->next) {
          _except_handlers.push_front(tmp->handler);
        }
      }

      TryCatchBlock::TryCatchBlock(ExpressionList* body,
                                     list<ExceptionHandler*> except_handlers) :
        _body(body),
        _except_handlers(except_handlers)
      {
      }

      TryCatchBlock::~TryCatchBlock()
      {
      }

      EXP_TYPE TryCatchBlock::type() const
      {
        return EXP_TRYCATCHBLOCK;
      }

      FancyObject* TryCatchBlock::eval(Scope *scope)
      {
        try {
          return _body->eval(scope);
        } catch(FancyException* ex) {
          for(list<ExceptionHandler*>::iterator it = _except_handlers.begin();
              it != _except_handlers.end();
              it++) {
            if((*it)->can_handle(ex->exception_class(), scope)) {
              return (*it)->handle(ex, scope);
            }
          }
          throw ex; // no handler defined
        }
      }
      
    }
  }
}
