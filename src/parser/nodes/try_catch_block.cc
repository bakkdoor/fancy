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
        if(_exception_class) {
          return the_class->subclass_of(_exception_class);
        }
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
                                   except_handler_list* except_handlers) :
        _body(body),
        _finally_block(NULL)
      {
        init_except_handlers(except_handlers);
      }

      TryCatchBlock::TryCatchBlock(ExpressionList* body,
                                   except_handler_list* except_handlers,
                                   ExpressionList* finally_block) :
        _body(body),
        _finally_block(finally_block)
      {
        init_except_handlers(except_handlers);
      }

      TryCatchBlock::TryCatchBlock(ExpressionList* body,
                                   list<ExceptionHandler*> except_handlers) :
        _body(body),
        _except_handlers(except_handlers),
        _finally_block(NULL)
      {
      }

      TryCatchBlock::TryCatchBlock(ExpressionList* body,
                                   list<ExceptionHandler*> except_handlers,
                                   ExpressionList* finally_block) :
        _body(body),
        _except_handlers(except_handlers),
        _finally_block(finally_block)
      {
      }

      TryCatchBlock::~TryCatchBlock()
      {
      }

      EXP_TYPE TryCatchBlock::type() const
      {
        return EXP_TRYCATCHBLOCK;
      }

      string TryCatchBlock::to_sexp() const
      {
        stringstream s;

        s << "[:try_catch_block, "
          << "[:try, "
          << _body->to_sexp() << "]"

          << "[:handlers, ";
        int size = _except_handlers.size();
        int count = 1;
        list<ExceptionHandler*>::const_iterator it;
        for(it = _except_handlers.begin(); it != _except_handlers.end(); it++) {
          s << "[:except_handler, "
            << (*it)->exception_class_name()->to_sexp() << ", "
            << (*it)->local_name()->to_sexp() << ", "
            << (*it)->body()->to_sexp() << "]";
          if(count < size) {
            s << ", ";
          }
          count++;
        }
        s << "]";

        if(_finally_block) {
          s << "[:finally, "
            << _finally_block->to_sexp()
            << "]";
        }

        s << "]";

        return s.str();
      }

      FancyObject* TryCatchBlock::eval(Scope *scope)
      {
        // OK, I admit this code looks kinda ugly. But it's pretty
        // simple actually:
        // Try to simply eval the body.
        // If there's a finally block defined, run it afterwars, then
        // return its last value.
        // If the body evaluation raises an exception:
        // -> check for an exception handler.
        // Again, always make sure that a finally block gets run, if
        // defined.

        try {
          if(!_finally_block) {
            return _body->eval(scope);
          } else {
            _body->eval(scope);
            return _finally_block->eval(scope);
          }
        } catch(FancyException* ex) {
          for(list<ExceptionHandler*>::iterator it = _except_handlers.begin();
              it != _except_handlers.end();
              it++) {
            if((*it)->can_handle(ex->exception_class(), scope)) {
              FancyObject* retval = (*it)->handle(ex, scope);
              // eval finally block if any given
              if(_finally_block) {
                retval = _finally_block->eval(scope);
              }
              return retval;
            }
          }
          // always eval finally block!
          if(_finally_block) {
            _finally_block->eval(scope);
          }
          throw ex; // no handler defined
        }
      }
      
      void TryCatchBlock::init_except_handlers(except_handler_list* except_handlers)
      {
        for(except_handler_list *tmp = except_handlers; tmp != NULL; tmp = tmp->next) {
          _except_handlers.push_front(tmp->handler);
        }
      }
    }
  }
}
