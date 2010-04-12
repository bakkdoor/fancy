#include "includes.h"

RequireStatement::RequireStatement(String_p filename)
{
  assert(filename);
  this->_filename = filename->value();
}

RequireStatement::~RequireStatement()
{
}

OBJ_TYPE RequireStatement::type() const
{
  return OBJ_REQUIRESTATEMENT;
}

FancyObject* RequireStatement::eval(Scope *scope)
{

  return nil;
}
