#include "includes.h"

#include "../string.h"


namespace fancy {
  namespace bootstrap {

    void init_console_class()
    {
      DEF_CLASSMETHOD(ConsoleClass,
                      "print:",
                      "Prints a given object on STDOUT.",
                      print);

      DEF_CLASSMETHOD(ConsoleClass,
                      "readln",
                      "Reads a line from STDIN and returns it as a String.",
                      readln);
    }


    /**
     * Console class methods
     */

    CLASSMETHOD(ConsoleClass, print)
    {
      EXPECT_ARGS("Console##print:", 1);
      cout << args[0]->call_method("to_s", 0, 0, scope)->to_s();
      return nil;
    }

    CLASSMETHOD(ConsoleClass, readln)
    {
      string input;
      getline(cin, input);
      return FancyString::from_value(input);
    }

  }
}
