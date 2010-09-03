#include "class_scope.h"
#include "class.h"
#include "errors.h"
#include "utils.h"

namespace fancy {

  ClassScope::ClassScope(Class* the_class, Scope* parent) :
    Scope(the_class, parent),
    _class(the_class)
  {
  }

  FancyObject* ClassScope::get(string identifier)
  {
    FancyObject* val = NULL;
    try {
      val = Scope::get(identifier);
      return val;
    } catch(UnknownIdentifierError* e) {
      if(Class* nested = _class->get_nested_class(identifier)) {
        return nested;
      } else {
        throw e;
      }
    }
  }

}
