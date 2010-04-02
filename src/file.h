#ifndef _FILE_H_
#define _FILE_H_

class File : public FancyObject
{
public:
  File(const string &filename, const string &mode, FILE *file);
  virtual ~File();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;

  string filename() const;
  string mode() const;
  FILE* file() const;

private:
  string _filename;
  string _mode;
  FILE *_file;
};

typedef File* File_p;

#endif /* _FILE_H_ */
