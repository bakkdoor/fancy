#ifndef _FILE_H_
#define _FILE_H_

class File : NativeObject
{
public:
  File(const string &filename, const string &mode);
  virtual ~File();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;

  string filename() const;
  string mode() const;

private:
  string _filename;
  string _mode;
  FancyObject_p _file_obj_cache;
};

typedef File* File_p;

#endif /* _FILE_H_ */
