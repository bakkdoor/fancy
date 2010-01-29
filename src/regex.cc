#include "includes.h"

Regex::Regex(const string &pattern) : Object(OBJ_REGEX), _pattern(pattern)
{
}

Regex::~Regex()
{
}

Object_p Regex::equal(const Object_p other) const
{
  if(!IS_REGEX(other))
    return nil;
  
  Regex_p other_regex = (Regex_p)other;
  if(this->_pattern == other_regex->_pattern)
    return t;
  return nil;
}

Object_p Regex::eval(Scope *scope)
{
  return this;
}

string Regex::to_s() const
{
  return "/" + this->_pattern + "/";
}

string Regex::pattern() const
{
  return this->_pattern;
}

Object_p Regex::match(String_p string) const
{
  // if match -> return t else nil
  // TODO: implement Regex matching! (via boost::regex?)
  return nil;
}
