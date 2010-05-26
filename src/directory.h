#ifndef _DIRECTORY_H_
#define _DIRECTORY_H_

namespace fancy {

  class Directory : public FancyObject
  {
  public:
    Directory(const string &dirname);
    virtual ~Directory();

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;

    /**
     * Returns the dirname set for this Directory object.
     * @return The dirname set for this Directory object.
     */
    string dirname() const;

  private:
    string _dirname;

  };

  typedef Directory* Directory_p;
}

#endif /* _DIRECTORY_H_ */
