#include "includes.h"

#include "../array.h"
#include "../string.h"

namespace fancy {
  namespace bootstrap {

    void init_system_class()
    {
      DEF_CLASSMETHOD(SystemClass,
                      "exit",
                      "Exit the running Fancy process.",
                      exit);

      DEF_CLASSMETHOD(SystemClass,
                      "do:",
                      "Runs the given string as a system() command.",
                      do);

      DEF_CLASSMETHOD(SystemClass,
                      "pipe:",
                      "Runs the given string as a popen() call and returns the output of the call as a string.",
                      pipe);
    }

    CLASSMETHOD(SystemClass, exit)
    {
      exit(0);
      return nil;
    }

    CLASSMETHOD(SystemClass, do)
    {
      EXPECT_ARGS("System##do:", 1);
      system(args[0]->to_s().c_str());
      return nil;
    }

    CLASSMETHOD(SystemClass, pipe)
    {
      // TODO: implement this using Files instead of returning an Array

      EXPECT_ARGS("System##pipe:", 1);
      FILE *f = popen(args[0]->to_s().c_str(), "r");
      vector<FancyObject*> lines;
      while(!feof(f)) {
        stringstream line;
        char c;
        while((c = fgetc(f)) && c != EOF && c != '\n') {
          line << c;
        }
        if(c != EOF) {
          lines.push_back(new String(line.str()));
        }
      }
      return new Array(lines);
    }

  }
}
