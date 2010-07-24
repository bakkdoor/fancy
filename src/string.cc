#include "../vendor/gc/include/gc.h"
#include "../vendor/gc/include/gc_cpp.h"
#include "../vendor/gc/include/gc_allocator.h"

#include "string.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  static string __fake_newline = "\\n";
  static string __fake_tab = "\\t";
  static string __newline = "\n";
  static string __tab =  "\t";

  FancyString::FancyString(const string &value) :
    FancyObject(StringClass), _value(value)
  {
    // do replacements of escape-characters
    replace(__fake_newline, __newline);
    replace(__fake_tab, __tab);
  }

  FancyObject* FancyString::equal(FancyObject* other) const
  {
    if(!IS_STRING(other))
      return nil;

    FancyString* other_string = (FancyString*)other;
    if(_value == other_string->_value)
      return t;
    return nil;
  }

  void FancyString::replace(string &what, string &with)
  {
    string::size_type next;

    for(next = _value.find(what); next != string::npos; next = _value.find(what, next)) {
      _value.replace(next, what.length(), with);
      next += with.length();
    }
  }

  map<string, FancyString*> FancyString::value_cache;
  FancyString* FancyString::from_value(const string &value)
  {
    if(value_cache.find(value) != value_cache.end()) {
      return value_cache[value];
    } else {
      // insert new value into value_cache & return new number value
      FancyString* new_string = new FancyString(value);
      value_cache[value] = new_string;
      return new_string;
    }
  }

}
