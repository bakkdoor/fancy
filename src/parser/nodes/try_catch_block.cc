#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      // ExceptionHandler
      
      ExceptionHandler::ExceptionHandler(Identifier_p exception_class_name,
                                         Identifier_p local_name,
                                         Expression_p body) :
        _exception_class_name(exception_class_name),
        _exception_class(0),
        _local_name(local_name),
        _body(body)
      {
      }

      ExceptionHandler::~ExceptionHandler()
      {
      }

      bool ExceptionHandler::can_handle(Class_p the_class, Scope *scope)
      {
        _exception_class = dynamic_cast<Class_p>(scope->get(_exception_class_name->name()));
        if(_exception_class)
          return _exception_class->subclass_of(the_class);
        return false;
      }

      FancyObject_p ExceptionHandler::handle(FancyException_p exception, Scope *scope)
      {
        Scope *catch_scope = new Scope(scope);
        if(_local_name->name() != "") {
          scope->define(_local_name->name(), exception);
        }
        return _body->eval(catch_scope);
      }

      // TryCatchBlock

      TryCatchBlock::TryCatchBlock(ExpressionList_p body,
                                     except_handler_list *except_handlers) :
        _body(body)
      {
        for(except_handler_list *tmp = except_handlers; tmp != NULL; tmp = tmp->next) {
          _except_handlers.push_front(tmp->handler);
        }
      }

      TryCatchBlock::TryCatchBlock(ExpressionList_p body,
                                     list<ExceptionHandler*> except_handlers) :
        _body(body),
        _except_handlers(except_handlers)
      {
      }

      TryCatchBlock::~TryCatchBlock()
      {
      }

      OBJ_TYPE TryCatchBlock::type() const
      {
        return OBJ_TRYCATCHBLOCK;
      }

      FancyObject_p TryCatchBlock::eval(Scope *scope)
      {
        try {
          return _body->eval(scope);
        } catch(FancyException_p ex) {
          for(list<ExceptionHandler*>::iterator it = _except_handlers.begin();
              it != _except_handlers.end();
              it++) {
            if((*it)->can_handle(ex->exception_class(), scope)) {
              return (*it)->handle(ex, scope);
            }
          }
        }
      }
      
    }
  }
}
