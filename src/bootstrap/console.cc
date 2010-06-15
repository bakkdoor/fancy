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

      DEF_CLASSMETHOD(ConsoleClass,
                      "clear",
                      "Clears the console.",
                      clear);
    }


    /**
     * Console class methods
     */

    CLASSMETHOD(ConsoleClass, print)
    {
      EXPECT_ARGS("Console##print:", 1);
      cout << args[0]->send_message("to_s", 0, 0, scope, self)->to_s();
      return nil;
    }

    CLASSMETHOD(ConsoleClass, readln)
    {
      string input;
      getline(cin, input);
      return FancyString::from_value(input);
    }

    CLASSMETHOD(ConsoleClass, clear)
    {
      cout << "\e[H\e[2J";
      return nil;
    }

  }
}
