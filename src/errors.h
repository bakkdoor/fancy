#ifndef _ERRORS_H_
#define _ERRORS_H_

namespace fancy {

  class UnknownIdentifierError : public FancyException
  {
  public:
    UnknownIdentifierError(const string &ident);
    ~UnknownIdentifierError();
  
    string identifier() const;
  
  private:
    string _identifier;
  };

  typedef UnknownIdentifierError* UnknownIdentifierError_p;

  class MethodNotFoundError : public FancyException
  {
  public:
    MethodNotFoundError(const string &method_name, Class_p klass);
    ~MethodNotFoundError();
  
    string method_name() const;
    Class_p get_class() const;
  
  private:
    string _method_name;
    Class_p _class;
  };

  typedef MethodNotFoundError* MethodNotFoundError_p;

  class IOError : public FancyException
  {
  public:
    IOError(const string &message, const string &filename);
    IOError(const string &message, const string &filename, Array_p modes);
    ~IOError();
  
    string filename() const;
    Array_p modes() const;
  
  private:
    string _filename;
    Array_p _modes;
  };

  typedef IOError* IOError_p;

}

#endif /* _ERRORS_H_ */
