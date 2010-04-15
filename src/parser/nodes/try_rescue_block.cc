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
        Scope *rescue_scope = new Scope(scope);
        if(_local_name->name() != "") {
          scope->define(_local_name->name(), exception);
        }
        return _body->eval(rescue_scope);
      }

      // BeginRescueBlock

      TryRescueBlock::TryRescueBlock(ExpressionList_p body,
                                     except_handler_list *except_handlers) :
        _body(body)
      {
        for(except_handler_list *tmp = except_handlers; tmp != NULL; tmp = tmp->next) {
          _except_handlers.push_front(tmp->handler);
        }
      }

      TryRescueBlock::TryRescueBlock(ExpressionList_p body,
                                     list<ExceptionHandler*> except_handlers) :
        _body(body),
        _except_handlers(except_handlers)
      {
      }

      TryRescueBlock::~TryRescueBlock()
      {
      }

      OBJ_TYPE TryRescueBlock::type() const
      {
        return OBJ_BEGINRESCUEBLOCK;
      }

      FancyObject_p TryRescueBlock::eval(Scope *scope)
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
