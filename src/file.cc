#include "includes.h"

namespace fancy {

  File::File(const string &filename, const string &mode, FILE *file) :
    FancyObject(FileClass),
    _filename(filename),
    _mode(mode),
    _file(file)
  {
  }

  File::~File()
  {
  }

  FancyObject_p File::equal(const FancyObject_p other) const
  {
    if(IS_FILE(other)) {
      File_p other_file = dynamic_cast<File_p>(other);
      if(this->_filename == other_file->_filename
         && this->_mode == other_file->_mode)
        return t;
    }
    return nil;
  }

  OBJ_TYPE File::type() const
  {
    return OBJ_FILE;
  }

  string File::to_s() const
  {
    return "<File:" + this->_filename + " [" + this->_mode + "]>";
  }

  string File::filename() const
  {
    return this->_filename;
  }

  string File::mode() const
  {
    return this->_mode;
  }

  FILE* File::file() const
  {
    return _file;
  }

}
