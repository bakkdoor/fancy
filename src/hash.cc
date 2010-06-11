#include <sstream>

#include "hash.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  Hash::Hash() : FancyObject(HashClass)
  {
  }

  Hash::Hash(map<FancyObject*, FancyObject*> map) :
    FancyObject(HashClass),
    _mappings(map)
  {
  }

  Hash::~Hash()
  {
  }

  FancyObject* Hash::set_value(FancyObject* key, FancyObject* value)
  {
    _mappings[key] = value;
    return value;
  }

  FancyObject* Hash::get_value(FancyObject* key) const
  {
    map<FancyObject*, FancyObject*>::const_iterator it = _mappings.find(key);
    if(it != _mappings.end()) {
      return (*it).second;
    } else {
      return nil;
    }
  }

  EXP_TYPE Hash::type() const
  {
    return EXP_HASH;
  }

  string Hash::to_s() const
  {
    stringstream s;
    s << "<[ ";

    for(map<FancyObject*, FancyObject*>::const_iterator iter = _mappings.begin(); iter != _mappings.end(); iter++) {
      s << iter->first->to_s();
      s << " => ";
      s << iter->second->to_s();
      s << " ";
    }

    s << "]>";
    return s.str();
  }

  vector<FancyObject*> Hash::keys()
  {
    vector<FancyObject*> keys(_mappings.size(), nil);
    int i = 0;
    for(map<FancyObject*, FancyObject*>::iterator it = _mappings.begin();
        it != _mappings.end();
        it++) {
      keys[i] = it->first;
      i++;
    }
    return keys;
  }

  vector<FancyObject*> Hash::values()
  {
    vector<FancyObject*> values(_mappings.size(), nil);
    int i = 0;
    for(map<FancyObject*, FancyObject*>::iterator it = _mappings.begin();
        it != _mappings.end();
        it++) {
      values[i] = it->second;
      i++;
    }
    return values;
  }

  int Hash::size() const
  {
    return _mappings.size();
  }

}
