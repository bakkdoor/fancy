#include "includes.h"

namespace fancy {

  Hash::Hash() : FancyObject(HashClass)
  {
  }

  Hash::Hash(map<FancyObject_p, FancyObject_p> map) :
    FancyObject(HashClass),
    _mappings(map)
  {
  }

  Hash::~Hash()
  {
  }

  FancyObject_p Hash::operator[](FancyObject_p key) const
  {
    map<FancyObject_p, FancyObject_p>::const_iterator citer = _mappings.find(key);
  
    if (citer == _mappings.end()) {
      // throw UnknownIdentifierError("Unknown key object!");
      return 0;
    }
  
    return (*citer).second;
  }

  FancyObject_p Hash::set_value(FancyObject_p key, FancyObject_p value)
  {
    _mappings[key] = value;
    return value;
  }

  FancyObject_p Hash::get_value(FancyObject_p key)
  {
    return (*this)[key];
  }

  FancyObject_p Hash::equal(const FancyObject_p other) const
  {
    if(!IS_HASH(other))
      return nil;

    Hash_p other_hash = (Hash_p)other;
    if((*this) == (*other_hash))
      return t;
    return nil;
  }

  EXP_TYPE Hash::type() const
  {
    return EXP_HASH;
  }

  string Hash::to_s() const
  {
    stringstream s;
    s << "{ ";

    for(map<FancyObject_p, FancyObject_p>::const_iterator iter = _mappings.begin(); iter != _mappings.end(); iter++) {
      s << iter->first->to_s();
      s << " => ";
      s << iter->second->to_s();
      s << " ";
    }

    s << "}";
    return s.str();
  }

  vector<FancyObject_p> Hash::keys()
  {
    vector<FancyObject_p> keys(_mappings.size(), nil);
    int i = 0;
    for(map<FancyObject_p, FancyObject_p>::iterator it = _mappings.begin();
        it != _mappings.end();
        it++) {
      keys[i] = it->first;
      i++;
    }
    return keys;
  }

  vector<FancyObject_p> Hash::values()
  {
    vector<FancyObject_p> values(_mappings.size(), nil);
    int i = 0;
    for(map<FancyObject_p, FancyObject_p>::iterator it = _mappings.begin();
        it != _mappings.end();
        it++) {
      values[i] = it->second;
      i++;
    }
    return values;
  }

  bool Hash::operator==(const Hash& other) const
  {
    for(map<FancyObject_p, FancyObject_p>::const_iterator iter = _mappings.begin(); 
        iter != _mappings.end(); 
        iter++) {
      if(iter->first->equal(other[iter->first]) == nil) {
        return false;
      }
    }
    return true;
  }

  int Hash::size() const
  {
    return _mappings.size();
  }

}
