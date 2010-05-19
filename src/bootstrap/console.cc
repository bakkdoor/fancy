#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Console class methods
     */
    METHOD(class_method_Console_print);
    METHOD(class_method_Console_println);
    METHOD(class_method_Console_readln);

    void init_console_class()
    {
      ConsoleClass->def_class_method("print:",
                                     new NativeMethod("print:",
                                                      "Prints a given object on STDOUT.",
                                                      class_method_Console_print));

      ConsoleClass->def_class_method("println:",
                                     new NativeMethod("println:",
                                                      "Prints a given object on STDOUT, followed by a newline.",
                                                      class_method_Console_println));

      ConsoleClass->def_class_method("readln",
                                     new NativeMethod("readln",
                                                      "Reads a line from STDIN and returns it as a String.",
                                                      class_method_Console_readln));
    }


    /**
     * Console class methods
     */

    FancyObject_p class_method_Console_print(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Console##print:", 1);
      cout << args[0]->call_method("to_s", 0, 0, scope)->to_s();
      return nil;
    }

    FancyObject_p class_method_Console_println(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Console##println:", 1);
      cout << args[0]->call_method("to_s", 0, 0, scope)->to_s() << "\n";
      return nil;
    }

    FancyObject_p class_method_Console_readln(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      string input;
      getline(cin, input);
      return String::from_value(input);
    }

  }
}
