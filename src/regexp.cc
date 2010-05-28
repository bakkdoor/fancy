#include "includes.h"

namespace fancy {

  Regexp::Regexp(const string &pattern) : FancyObject(RegexpClass), _pattern(pattern)
  {
  }

  Regexp::~Regexp()
  {
  }

  FancyObject_p Regexp::equal(const FancyObject_p other) const
  {
    if(!IS_REGEX(other))
      return nil;
  
    Regexp_p other_regex = (Regexp_p)other;
    if(_pattern == other_regex->_pattern)
      return t;
    return nil;
  }

  EXP_TYPE Regexp::type() const
  {
    return EXP_REGEX;
  }

  string Regexp::to_s() const
  {
    return "/" + _pattern + "/";
  }

  string Regexp::pattern() const
  {
    return _pattern;
  }

  FancyObject_p Regexp::match(String_p string) const
  {
    // if match -> return t else nil
    // TODO: implement Regexp matching! (via boost::regex?)
    return nil;
  }

}
