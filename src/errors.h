#ifndef _ERRORS_H_
#define _ERRORS_H_

#include <string>

#include "fancy_exception.h"
#include "class.h"
#include "string.h"

using namespace std;

namespace fancy {

  FancyObject* new_method_not_found_error(const string& method_name,
                                          Class* for_class,
                                          Scope* scope);

  FancyObject* new_method_not_found_error(const string& method_name,
                                          Class* for_class,
                                          Scope* scope,
                                          const string& reason);

  FancyObject* new_division_by_zero_error(Scope* scope);

  FancyObject* new_io_error(const string &message, const string &filename, Scope* scope);
  FancyObject* new_io_error(const string &message, const string &filename, Array* modes, Scope* scope);

  class UnknownIdentifierError : public FancyException
  {
  public:
    UnknownIdentifierError(const string &ident);
    ~UnknownIdentifierError() {}

    string identifier() const { return _identifier; }

  private:
    string _identifier;
  };

}

#endif /* _ERRORS_H_ */
