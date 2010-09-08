#include "../vendor/gc/include/gc.h"
#include "../vendor/gc/include/gc_cpp.h"
#include "../vendor/gc/include/gc_allocator.h"

#include "utils.h"

#include <algorithm>
#include <iterator>

namespace fancy {

  ostream& warn(string message)
  {
    cout << "[WARNING] " << message;
    return cout;
  }

  ostream& warnln(string message)
  {
    warn(message) << endl;
    return cout;
  }

  ostream& error(string message)
  {
    cerr << "[ERROR] " << message;
    return cerr;
  }

  ostream& errorln(string message)
  {
    error(message) << endl;
    return cerr;
  }

  vector<string> string_split(const string& str, const string& seperator, const bool keep_empty) {
    vector<string> result;
    if (seperator.empty()) {
      result.push_back(str);
      return result;
    }
    string::const_iterator substart = str.begin(), subend;
    while (true) {
      subend = search(substart, str.end(), seperator.begin(), seperator.end());
      string temp(substart, subend);
      if (keep_empty || !temp.empty()) {
        result.push_back(temp);
      }
      if (subend == str.end()) {
	break;
      }
      substart = subend + seperator.size();
    }
    if(result.back() == "") {
      result.pop_back();
    }
    return result;
  }

  string string_replace(string& str, string& what, string& with)
  {
    string s = str;
    string::size_type next;

    for(next = s.find(what); next != string::npos; next = s.find(what, next)) {
      s.replace(next, what.length(), with);
      next += with.length();
    }

    return s;
  }

}
