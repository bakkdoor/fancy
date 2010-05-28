#include "includes.h"

namespace fancy {

  Directory::Directory(const string &dirname) :
    FancyObject(DirectoryClass),
    _dirname(dirname)
  {
  }

  Directory::~Directory()
  {
  }

  FancyObject_p Directory::equal(const FancyObject_p other) const
  {
    if(Directory_p other_dir = dynamic_cast<Directory_p>(other)) {
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
