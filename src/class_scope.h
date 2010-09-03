#ifndef _CLASS_SCOPE_H_
#define _CLASS_SCOPE_H_

#include "scope.h"

namespace fancy {

  class ClassScope : public Scope
  {
  public:
    ClassScope(Class* the_class, Scope* parent);
    virtual ~ClassScope() {}

    virtual FancyObject* get(string identifier);

  private:
    Class* _class;
  };

}

#endif /* _CLASS_SCOPE_H_ */
