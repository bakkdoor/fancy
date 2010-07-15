#include "utils.h"

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

  void string_split(string str, string separator, vector<string>* results)
  {
    int found;
    found = str.find_first_of(separator);
    while(found != string::npos){
      if(found > 0){
        results->push_back(str.substr(0,found));
      }
      str = str.substr(found+1);
      found = str.find_first_of(separator);
    }
    if(str.length() > 0){
      results->push_back(str);
    }
  }

}
