#include "includes.h"

Regex::Regex(const string &pattern) : FancyObject(RegexClass), _pattern(pattern)
{
}

Regex::~Regex()
{
}

NativeObject_p Regex::equal(const NativeObject_p other) const
{
  if(!IS_REGEX(other))
    return nil;
  
  Regex_p other_regex = (Regex_p)other;
  if(this->_pattern == other_regex->_pattern)
    return t;
  return nil;
}

OBJ_TYPE Regex::type() const
{
  return OBJ_REGEX;
}

string Regex::to_s() const
{
  return "/" + this->_pattern + "/";
}

string Regex::pattern() const
{
  return this->_pattern;
}

NativeObject_p Regex::match(String_p string) const
{
  // if match -> return t else nil
  // TODO: implement Regex matching! (via boost::regex?)
  return nil;
}
