#ifndef _FANCY_EXCEPTION_H_
#define _FANCY_EXCEPTION_H_

namespace fancy {

  class FancyException : public FancyObject
  {
  public:
    FancyException(Class_p Exception_class);
    FancyException(const string &message, Class_p Exception_class);
    FancyException(const string &message);
    FancyException(FancyObject_p exception_value, const string &message);

    virtual ~FancyException();

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;

    string message() const;
    Class_p exception_class() const;
    FancyObject_p exception_value();

  private:
    FancyObject_p _exception_value;
    Class_p _exception_class;
    string _message;
  };

  typedef FancyException* FancyException_p;

}

#endif /* _FANCY_EXCEPTION_H_ */
