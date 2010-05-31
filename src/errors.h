#ifndef _ERRORS_H_
#define _ERRORS_H_

#include <string>

#include "fancy_exception.h"
#include "class.h"

using namespace std;

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

  class MethodNotFoundError : public FancyException
  {
  public:
    MethodNotFoundError(const string &method_name, Class* klass);
    ~MethodNotFoundError();
  
    string method_name() const;
    Class* get_class() const;
  
  private:
    string _method_name;
    Class* _class;
  };

  class IOError : public FancyException
  {
  public:
    IOError(const string &message, const string &filename);
    IOError(const string &message, const string &filename, Array* modes);
    ~IOError();
  
    string filename() const;
    Array* modes() const;
  
  private:
    string _filename;
    Array* _modes;
  };

  class DivisionByZeroError : public FancyException
  {
  public:
    DivisionByZeroError();
    ~DivisionByZeroError();
  };
}

#endif /* _ERRORS_H_ */
