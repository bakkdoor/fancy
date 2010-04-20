#ifndef _BOOTSTRAP_CONSOLE_H_
#define _BOOTSTRAP_CONSOLE_H_

namespace fancy {
  namespace bootstrap {

    void init_console_class();

    /**
     * Console class methods
     */
    FancyObject_p class_method_Console_print(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p class_method_Console_println(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);
    FancyObject_p class_method_Console_readln(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

  }
}

#endif /* _BOOTSTRAP_CONSOLE_H_ */
