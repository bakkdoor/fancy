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
    ~UnknownIdentifierError() {}

    string identifier() const { return _identifier; }

  private:
    string _identifier;
  };

  class MethodNotFoundError : public FancyException
  {
  public:
    MethodNotFoundError(const string &method_name, Class* for_class);
    MethodNotFoundError(const string &method_name, Class* for_class, const string &reason);
    ~MethodNotFoundError() {}

    string method_name() const { return _method_name; }
    Class* for_class() const { return _for_class; }

  private:
    string _method_name;
    Class* _for_class;
  };

  class IOError : public FancyException
  {
  public:
    IOError(const string &message, const string &filename);
    IOError(const string &message, const string &filename, Array* modes);
    ~IOError() {}

    string filename() const { return _filename; }
    Array* modes() const { return _modes; }

  private:
    string _filename;
    Array* _modes;
  };

  class DivisionByZeroError : public FancyException
  {
  public:
    DivisionByZeroError();
    ~DivisionByZeroError() {}
  };
}

#endif /* _ERRORS_H_ */
