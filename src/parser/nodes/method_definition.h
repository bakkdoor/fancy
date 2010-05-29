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

        virtual EXP_TYPE type() const;
        virtual FancyObject* eval(Scope *scope);
 
      private:
        string method_name();
        list< pair<Identifier*, Identifier*> > _method_args;
        Method* _method;
        Identifier* _method_name;
      };

    }
  }
}

#endif /* _METHOD_DEFINITION_H_ */
