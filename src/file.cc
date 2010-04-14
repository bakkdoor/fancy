#include "includes.h"

namespace fancy {

  File::File(const string &filename, ios_base::openmode mode) :
    FancyObject(FileClass),
    _filename(filename),
    _mode(mode)
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
    return "<File:" + this->_filename + ">";; // + " [" + this->_mode + "]>";
  }

  string File::filename() const
  {
    return this->_filename;
  }

  ios_base::openmode File::mode() const
  {
    return this->_mode;
  }

  fstream& File::file()
  {
    return _file;
  }

  void File::open()
  {
    _file.open(_filename.c_str(), _mode);
  }

  bool File::is_open()
  {
    return _file.is_open();
  }

  bool File::eof()
  {
    return _file.eof();
  }

  void File::close()
  {
    // if(_file) {
    //   fclose(_file);
    //   _file = 0;
    // }
    _file.close();
  }

  bool File::good() const
  {
    return _file.good();
  }

}
