#ifndef _BOOTSTRAP_SCOPE_H_
#define _BOOTSTRAP_SCOPE_H_

namespace fancy {
  namespace bootstrap {

    void init_scope_class();

    /**
     * Scope instance methods
     */
    FancyObject_p method_Scope_define__value(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
    FancyObject_p method_Scope_parent(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
    FancyObject_p method_Scope_get(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

  }
}

#endif /* _BOOTSTRAP_SCOPE_H_ */
