#ifndef _METHOD_DEFINITION_H_
#define _METHOD_DEFINITION_H_

#include <string>

#include "../../expression.h"
#include "../../method.h"
#include "identifier.h"

using namespace std;

namespace fancy {
  namespace parser {
    namespace nodes {

      class MethodDefExpr : public Expression
      {
      public:
        MethodDefExpr(Identifier* name, Method* method); // method takes no arguments
        MethodDefExpr(list< pair<Identifier*, Identifier*> > args_with_name, Method* method);
        virtual ~MethodDefExpr() {}

        virtual EXP_TYPE type() const { return EXP_METHODDEFEXPR; }
        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;
 
      protected:
        string method_name() const;
        list< pair<Identifier*, Identifier*> > _method_args;
        Method* _method;
        Identifier* _method_name;
      };

      class PrivateMethodDefExpr : public MethodDefExpr
      {
      public:
        PrivateMethodDefExpr(Identifier* name, Method* method); // method takes no arguments
        PrivateMethodDefExpr(list< pair<Identifier*, Identifier*> > args_with_name, Method* method);
        virtual ~PrivateMethodDefExpr() {}

        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;
      };

      class ProtectedMethodDefExpr : public MethodDefExpr
      {
      public:
        ProtectedMethodDefExpr(Identifier* name, Method* method); // method takes no arguments
        ProtectedMethodDefExpr(list< pair<Identifier*, Identifier*> > args_with_name, Method* method);
        virtual ~ProtectedMethodDefExpr() {}

        virtual FancyObject* eval(Scope *scope);
        virtual string to_sexp() const;
      };

    }
  }
}

#endif /* _METHOD_DEFINITION_H_ */
