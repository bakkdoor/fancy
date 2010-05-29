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

  EXP_TYPE Directory::type() const
  {
    return EXP_DIRECTORY;
  }

  string Directory::to_s() const
  {
    return "<Directory:" + _dirname + ">";
  }

  string Directory::dirname() const
  {
    return _dirname;
  }

}
