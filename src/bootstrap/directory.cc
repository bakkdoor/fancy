#include "../../vendor/gc/include/gc.h"
#include "../../vendor/gc/include/gc_cpp.h"
#include "../../vendor/gc/include/gc_allocator.h"

#include "includes.h"

#include "../directory.h"
#include "../errors.h"


namespace fancy {
  namespace bootstrap {

    void init_directory_class()
    {
      DEF_CLASSMETHOD(DirectoryClass,
                      "create:",
                      "Creates a Directory with a given name, if it doesn't already exist.",
                      create);
    }

    CLASSMETHOD(DirectoryClass, create)
    {
      EXPECT_ARGS("Directory##create:", 1);
      string dirname = args[0]->to_s();
      if(mkdir(dirname.c_str(), 0777) == 0) {
        return new Directory(dirname);
      } else {
        throw new_io_error("Could not create directory: ", dirname, scope);
      }
    }

  }
}
