#include "../vendor/gc/include/gc.h"
#include "../vendor/gc/include/gc_cpp.h"
#include "../vendor/gc/include/gc_allocator.h"

#include "directory.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  Directory::Directory(const string &dirname) :
    FancyObject(DirectoryClass),
    _dirname(dirname)
  {
  }

  Directory::~Directory()
  {
  }

  FancyObject* Directory::equal(FancyObject* other) const
  {
    if(Directory* other_dir = dynamic_cast<Directory*>(other)) {
      if(_dirname == other_dir->_dirname) {
        return t;
      }
    }
    return nil;
  }

  string Directory::to_s() const
  {
    return "<Directory:" + _dirname + ">";
  }

}
