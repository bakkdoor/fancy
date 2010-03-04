#include "includes.h"

Hash::Hash(key_val_node *key_val_list) : NativeObject(OBJ_HASH)
{
  for(; key_val_list; key_val_list = key_val_list->next) {
    this->mappings[key_val_list->key] = key_val_list->val;
  }
}

Hash::Hash(map<NativeObject_p, NativeObject_p> map) : NativeObject(OBJ_HASH), mappings(map)
{
}

Hash::~Hash()
{
}

NativeObject_p Hash::operator[](NativeObject_p key) const
{
  map<NativeObject_p, NativeObject_p>::const_iterator citer = this->mappings.find(key);
  
  if (citer == this->mappings.end()) {
    // throw UnknownIdentifierError("Unknown key object!");
    return 0;
  }
  
  return (*citer).second;
}

NativeObject_p Hash::set_value(NativeObject_p key, NativeObject_p value)
{
  this->mappings[key] = value;
  return value;
}

NativeObject_p Hash::equal(const NativeObject_p other) const
{
  if(!IS_HASH(other))
    return nil;

  Hash_p other_hash = (Hash_p)other;
  if((*this) == (*other_hash))
    return t;
  return nil;
}

NativeObject_p Hash::eval(Scope *scope)
{
  return this;
}

string Hash::to_s() const
{
  stringstream s;
  s << "{ ";

  for(map<NativeObject_p, NativeObject_p>::const_iterator iter = this->mappings.begin(); iter != this->mappings.end(); iter++) {
    s << iter->first->to_s();
    s << " => ";
    s << iter->second->to_s();
    s << " ";
  }

  s << "}";
  return s.str();
}

bool Hash::operator==(const Hash& other) const
{
  for(map<NativeObject_p, NativeObject_p>::const_iterator iter = this->mappings.begin(); 
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
