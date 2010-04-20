#ifndef _BOOTSTRAP_BLOCK_H_
#define _BOOTSTRAP_BLOCK_H_

namespace fancy {
  namespace bootstrap {

    void init_block_class();

    /**
     * Block instance methods
     */
    FancyObject_p method_Block_call(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Block_call_with_arg(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Block_while_true(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Block_if(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Block_unless(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Block_arguments(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p method_Block_argcount(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

  }
}
#endif /* _BOOTSTRAP_BLOCK_H_ */
