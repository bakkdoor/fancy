#include "includes.h"

NativeObject::NativeObject()
{
}

NativeObject::~NativeObject()
{
}

OBJ_TYPE NativeObject::type() const
{
  return this->obj_type;
}

string NativeObject::to_s() const
{
  stringstream s;
  s << "[unkown object (" << this->type() << ")]";
  return s.str();
}
