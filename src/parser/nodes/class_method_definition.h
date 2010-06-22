#ifndef _CLASS_METHOD_DEFINITION_H_
#define _CLASS_METHOD_DEFINITION_H_

#include <string>

#include "../../expression.h"
#include "../../method.h"
#include "identifier.h"

using namespace std;

namespace fancy {
  namespace parser {
    namespace nodes {

      class ClassMethodDefExpr : public Expression
      {
      public:
        ClassMethodDefExpr(Identifier* class_name, Identifier* method_name, Method* method); // method takes no arguments
        ClassMethodDefExpr(Identifier* class_name, list< pair<Identifier*, Identifier*> > args_with_name, Method* method);
        virtual ~ClassMethodDefExpr() {}

        virtual EXP_TYPE type() const;
        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;
 
      protected:
        string method_name() const;
        Identifier* _class_name;
        Identifier* _method_name;
        Method* _method;
        list< pair<Identifier*, Identifier*> > _method_args;
      };

      class PrivateClassMethodDefExpr : public ClassMethodDefExpr
      {
      public:
        PrivateClassMethodDefExpr(Identifier* class_name, Identifier* method_name, Method* method); // method takes no arguments
        PrivateClassMethodDefExpr(Identifier* class_name, list< pair<Identifier*, Identifier*> > args_with_name, Method* method);
        virtual ~PrivateClassMethodDefExpr() {}

        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;
      };

      class ProtectedClassMethodDefExpr : public ClassMethodDefExpr
      {
      public:
        ProtectedClassMethodDefExpr(Identifier* class_name, Identifier* method_name, Method* method); // method takes no arguments
        ProtectedClassMethodDefExpr(Identifier* class_name, list< pair<Identifier*, Identifier*> > args_with_name, Method* method);
        virtual ~ProtectedClassMethodDefExpr() {}

        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;
      };
    }
  }
}

#endif /* _CLASS_METHOD_DEFINITION_H_ */
