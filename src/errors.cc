#include "includes.h"

namespace fancy {

  UnknownIdentifierError::UnknownIdentifierError(const string &ident) : 
    _identifier(ident) {}

  UnknownIdentifierError::~UnknownIdentifierError() {}

  string UnknownIdentifierError::identifier() const
  {
    return this->_identifier;
  }

}
