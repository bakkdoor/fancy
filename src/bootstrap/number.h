#ifndef _BOOTSTRAP_NUMBER_H_
#define _BOOTSTRAP_NUMBER_H_

namespace fancy {
  namespace bootstrap {

    void init_number_class();

    /**
     * Number instance methods
     */
    FancyObject_p method_Number_plus(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Number_minus(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Number_multiply(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Number_divide(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Number_lt(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Number_lt_eq(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Number_gt(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Number_gt_eq(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Number_eq(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Number_times(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Number_modulo(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

  }
}

#endif /* _BOOTSTRAP_NUMBER_H_ */
