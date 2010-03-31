#include "includes.h"

File::File(const string &filename, const string &mode, FILE *file) :
  NativeObject(),
  _filename(filename),
  _mode(mode),
  _file(file),
  _file_obj_cache(0)
{
}

File::~File()
{
}

NativeObject_p File::equal(const NativeObject_p other) const
{
  if(IS_FILE(other)) {
    File_p other_file = dynamic_cast<File_p>(other);
    if(this->_filename == other_file->_filename
       && this->_mode == other_file->_mode)
      return t;
  }
  return nil;
}

FancyObject_p File::eval(Scope *scope)
{
  if(!_file_obj_cache) {
    _file_obj_cache = FileClass->create_instance(this);
  }
  return _file_obj_cache;
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
