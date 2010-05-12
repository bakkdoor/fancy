#ifndef _FILE_H_
#define _FILE_H_

namespace fancy {

  /**
   * File class that represents File objects in Fancy.
   */
  class File : public FancyObject
  {
  public:
    /**
     * File constructor.
     * @param filename Name of the file to be used.
     * @param modes Fancy Array of access modes. May hold the
     * following Symbols: :append, :read, :write, :binary, :at_end,
     * :truncate
     */
    File(const string &filename, Array_p modes);
    virtual ~File();

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;

    /**
     * Returns the filename set for this File object.
     * @return The filename set for this File object.
     */
    string filename() const;

    /**
     * Returns the modes Array for this File object.
     * @return The modes Array for this File object.
     */
    Array_p modes() const;

    /**
     * Returns a C++ ios_base::openmode object representing the Files
     * modes.
     * @return C++ ios_base::openmode object representing the Files
     * modes.
     */
    ios_base::openmode openmode() const;

    /**
     * Returns the C++ filestream object for this File object.
     * @return The C++ filestream object for this File object.
     */
    fstream& file();

    /**
     * Opens the File.
     */
    void open();

    /**
     * Indicates, if the File is opened.
     * @return true, if opened, false otherwise.
     */
    bool is_open();

    /**
     * Indicates, if the file buffer is at the end.
     * @return true, if EOF, false otherwise.
     */
    bool eof();

    /**
     * Closes the file.
     */
    void close();

    /**
     * Indicates, if the file stream is in a good state (for reading, writing etc.).
     * @return true, if File in good state, false otherwise.
     */
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
