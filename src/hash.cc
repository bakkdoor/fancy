#include "includes.h"

namespace fancy {

  Hash::Hash() : FancyObject(HashClass)
  {
  }

  Hash::Hash(map<FancyObject_p, FancyObject_p> map) :
    FancyObject(HashClass),
    mappings(map)
  {
  }

  Hash::~Hash()
  {
  }

  FancyObject_p Hash::operator[](FancyObject_p key) const
  {
    map<FancyObject_p, FancyObject_p>::const_iterator citer = this->mappings.find(key);
  
    if (citer == this->mappings.end()) {
      // throw UnknownIdentifierError("Unknown key object!");
      return 0;
    }
  
    return (*citer).second;
  }

  FancyObject_p Hash::set_value(FancyObject_p key, FancyObject_p value)
  {
    this->mappings[key] = value;
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

  OBJ_TYPE Hash::type() const
  {
    return OBJ_HASH;
  }

  string Hash::to_s() const
  {
    stringstream s;
    s << "{ ";

    for(map<FancyObject_p, FancyObject_p>::const_iterator iter = this->mappings.begin(); iter != this->mappings.end(); iter++) {
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
    vector<FancyObject_p> keys(this->mappings.size(), nil);
    int i = 0;
    for(map<FancyObject_p, FancyObject_p>::iterator it = this->mappings.begin();
        it != this->mappings.end();
        it++) {
      keys[i] = it->first;
      i++;
    }
    return keys;
  }

  vector<FancyObject_p> Hash::values()
  {
    vector<FancyObject_p> values(this->mappings.size(), nil);
    int i = 0;
    for(map<FancyObject_p, FancyObject_p>::iterator it = this->mappings.begin();
        it != this->mappings.end();
        it++) {
      values[i] = it->second;
      i++;
    }
    return values;
  }

  bool Hash::operator==(const Hash& other) const
  {
    for(map<FancyObject_p, FancyObject_p>::const_iterator iter = this->mappings.begin(); 
        iter != this->mappings.end(); 
        iter++) {
      if(iter->first->equal(other[iter->first]) == nil) {
        return false;
      }
    }
    return true;
  }

  int Hash::size() const
  {
    return this->mappings.size();
  }

}
