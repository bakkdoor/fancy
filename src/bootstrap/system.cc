#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_system_class()
    {
      DEF_CLASSMETHOD(SystemClass,
                      "exit",
                      "Exit the running Fancy process.",
                      exit);
    }

    CLASSMETHOD(SystemClass, exit)
    {
      exit(0);
    }

  }
}
