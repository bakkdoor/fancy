#include "includes.h"

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
    }

    CLASSMETHOD(SystemClass, exit)
    {
      exit(0);
      return nil;
    }

    CLASSMETHOD(SystemClass, do)
    {
      system(args[0]->to_s().c_str());
      return nil;
    }

  }
}
