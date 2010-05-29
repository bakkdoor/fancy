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

        virtual EXP_TYPE type() const;
        virtual FancyObject* eval(Scope *scope);
 
      private:
        string method_name();
        Identifier* _class_name;
        Identifier* _method_name;
        Method* _method;
        list< pair<Identifier*, Identifier*> > _method_args;
      };

    }
  }
}

#endif /* _CLASS_METHOD_DEFINITION_H_ */
