#ifndef _BOOTSTRAP_CONSOLE_H_
#define _BOOTSTRAP_CONSOLE_H_

void init_console_class();

/**
 * Console class methods
 */
FancyObject_p class_method_Console_print(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
FancyObject_p class_method_Console_println(FancyObject_p self, list<FancyObject_p> args, Scope *scope);
FancyObject_p class_method_Console_readln(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

#endif /* _BOOTSTRAP_CONSOLE_H_ */
