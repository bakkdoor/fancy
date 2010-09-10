#include "../../../vendor/gc/include/gc.h"
#include "../../../vendor/gc/include/gc_cpp.h"
#include "../../../vendor/gc/include/gc_allocator.h"

#include <sstream>

#include "method_definition.h"
#include "../../class.h"
#include "../../native_method.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      ClassConstructorMethod::ClassConstructorMethod(string method_name, Class* for_class) :
        _method_name(method_name),
        _for_class(for_class)
      {
      }

      FancyObject* ClassConstructorMethod::call(FancyObject* self, FancyObject* *args, int argc, Scope *scope, FancyObject* sender)
      {
        FancyObject* obj = _for_class->create_instance();
        obj->send_message(_method_name, args, argc, scope, sender);
        return obj;
      }

      FancyObject* ClassConstructorMethod::call(FancyObject *self, Scope *scope, FancyObject* sender)
      {
        FancyObject* args[0] = {};
        return call(self, args, 0, scope, sender);
      }

      // MethodDefExpr

      MethodDefExpr::MethodDefExpr(Identifier* method_name, Method* method) :
        _method(method), _method_name(method_name)
      {
      }

      MethodDefExpr::MethodDefExpr(list< pair<Identifier*, Identifier*> > args_with_name, Method* method) :
        _method_args(args_with_name), _method(method), _method_name(0)
      {
      }

      FancyObject* MethodDefExpr::eval(Scope *scope)
      {
        // set method name explicitly (somehow method names aren't set
        // correctly so this is necessary)
        _method->set_name(method_name());
        Class* the_class = scope->current_class();
        the_class->def_method(method_name(), _method);
        if(is_constructor_method()) {
          generate_constructor_class_method(the_class, scope);
        }
        return _method;
      }

      string MethodDefExpr::to_sexp() const
      {
        stringstream s;
        s << "['method_def, ";
        // insert method
        _method->set_name(method_name());
        s << _method->to_sexp() << "]";
        return s.str();
      }

      bool MethodDefExpr::is_constructor_method() const
      {
        string method_name = this->method_name();
        if(method_name.substr(0,11) == "initialize:" && method_name.size() > 11) {
          return true;
        }
        return false;
      }

      void MethodDefExpr::generate_constructor_class_method(Class* for_class, Scope* scope)
      {
        string method_name = this->method_name();
        string new_method_name = method_name;
        new_method_name.replace(0, 11, "new:");
        for_class->def_class_method(new_method_name, new ClassConstructorMethod(method_name, for_class));
      }

      string MethodDefExpr::method_name() const
      {
        if(!_method_name) {
          stringstream s;
          list< pair<Identifier*, Identifier*> >::const_iterator it;
          for(it = _method_args.begin(); it != _method_args.end(); it++) {
            s << it->first->name() << ":";
          }

          return s.str();
        } else {
          return _method_name->name();
        }
      }


      /**
       * PrivateMethodDefExpr
       */

      PrivateMethodDefExpr::PrivateMethodDefExpr(Identifier* method_name, Method* method) :
        MethodDefExpr(method_name, method)
      {
      }

      PrivateMethodDefExpr::PrivateMethodDefExpr(list< pair<Identifier*, Identifier*> > args_with_name, Method* method) :
        MethodDefExpr(args_with_name, method)
      {
      }

      FancyObject* PrivateMethodDefExpr::eval(Scope *scope)
      {
        _method->set_name(method_name());
        scope->current_class()->def_private_method(method_name(), _method);
        return _method;
      }

      string PrivateMethodDefExpr::to_sexp() const
      {
        return "['private, " + MethodDefExpr::to_sexp() + "]";
      }

      /**
       * ProtectedMethodDefExpr
       */

      ProtectedMethodDefExpr::ProtectedMethodDefExpr(Identifier* method_name, Method* method) :
        MethodDefExpr(method_name, method)
      {
      }

      ProtectedMethodDefExpr::ProtectedMethodDefExpr(list< pair<Identifier*, Identifier*> > args_with_name, Method* method) :
        MethodDefExpr(args_with_name, method)
      {
      }

      FancyObject* ProtectedMethodDefExpr::eval(Scope *scope)
      {
        _method->set_name(method_name());
        scope->current_class()->def_protected_method(method_name(), _method);
        return _method;
      }

      string ProtectedMethodDefExpr::to_sexp() const
      {
        return "['protected, " + MethodDefExpr::to_sexp() + "]";
      }
    }
  }
}
