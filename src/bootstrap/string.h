#ifndef _BOOTSTRAP_STRING_H_
#define _BOOTSTRAP_STRING_H_

namespace fancy {
  namespace bootstrap {

    void init_string_class();

    /**
     * String class methods
     */
    FancyObject_p class_method_String_new(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

    /**
     * String instance methods
     */
    FancyObject_p method_String_downcase(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_String_upcase(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_String_from__to(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_String_eq(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_String_plus(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_String_each(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_String_at(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

  }
}

#endif /* _BOOTSTRAP_STRING_H_ */
