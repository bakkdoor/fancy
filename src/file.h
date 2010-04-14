#ifndef _FILE_H_
#define _FILE_H_

namespace fancy {

  class File : public FancyObject
  {
  public:
    File(const string &filename, Array_p modes);
    virtual ~File();

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;

    string filename() const;
    Array_p modes() const;
    ios_base::openmode openmode() const;
    fstream& file();

    void open();
    bool is_open();
    bool eof();
    void close();
    bool good() const;

  private:
    void init_openmode(Array_p modes);
    string _filename;
    Array_p _modes;
    ios_base::openmode _openmode;
    fstream _file;
  };

  typedef File* File_p;

}

#endif /* _FILE_H_ */
