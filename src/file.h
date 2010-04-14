#ifndef _FILE_H_
#define _FILE_H_

namespace fancy {

  class File : public FancyObject
  {
  public:
    File(const string &filename, ios_base::openmode mode);
    virtual ~File();

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;

    string filename() const;
    ios_base::openmode mode() const;
    fstream& file();

    void open();
    bool is_open();
    bool eof();
    void close();
    bool good() const;

  private:
    string _filename;
    ios_base::openmode _mode;
    fstream _file;
  };

  typedef File* File_p;

}

#endif /* _FILE_H_ */
