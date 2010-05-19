#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Console class methods
     */
    METHOD(Console_class__print);
    METHOD(Console_class__println);
    METHOD(Console_class__readln);

    void init_console_class()
    {
      ConsoleClass->def_class_method("print:",
                                     new NativeMethod("print:",
                                                      "Prints a given object on STDOUT.",
                                                      Console_class__print));

      ConsoleClass->def_class_method("println:",
                                     new NativeMethod("println:",
                                                      "Prints a given object on STDOUT, followed by a newline.",
                                                      Console_class__println));

      ConsoleClass->def_class_method("readln",
                                     new NativeMethod("readln",
                                                      "Reads a line from STDIN and returns it as a String.",
                                                      Console_class__readln));
    }


    /**
     * Console class methods
     */

    METHOD(Console_class__print)
    {
      EXPECT_ARGS("Console##print:", 1);
      cout << args[0]->call_method("to_s", 0, 0, scope)->to_s();
      return nil;
    }

    METHOD(Console_class__println)
    {
      EXPECT_ARGS("Console##println:", 1);
      cout << args[0]->call_method("to_s", 0, 0, scope)->to_s() << "\n";
      return nil;
    }

    METHOD(Console_class__readln)
    {
      string input;
      getline(cin, input);
      return String::from_value(input);
    }

  }
}
