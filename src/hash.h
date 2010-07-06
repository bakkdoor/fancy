#ifndef _HASH_H_
#define _HASH_H_

#include <vector>
#include <map>

#include "fancy_object.h"

using namespace std;

namespace fancy {

  /**
   * Hash class representing Hashes (HashMaps / Dictionaries) in Fancy.
   */
  class Hash : public FancyObject
  {
  public:
    /**
     * Hash constructor. Creates empty Hash object.
     */
    Hash();

    /**
     * Hash constructor. Creates Hash object from a given C++ map.
     * @param mappings C++ map containing key-value pairs for the Hash object to contain.
     */
    Hash(map<FancyObject*, FancyObject*> mappings);
    ~Hash() {}

    /**
     * Returns the value for a given key in the Hash (or nil, if not defined).
     * @param key The FancyObject used as the key for an entry in the Hash.
     * @return The value for the given key, or nil if key not in Hash.
     */
    FancyObject* get_value(FancyObject* key) const;

    /**
     * Sets the value for a given key in the Hash.
     * @param key The key object.
     * @param value The value for the given key.
     * @return Returns the value passed in.
     */
    FancyObject* set_value(FancyObject* key, FancyObject* value);

    /**
     * See FancyObject for these methods.
     */
    virtual EXP_TYPE type() const { return EXP_HASH; }
    virtual string to_s() const;

    /**
     * Returns a C++ vector of all the keys in the Hash.
     * @return C++ vector of all the keys in the Hash.
     */
    vector<FancyObject*> keys();

    /**
     * Returns a C++ vector of all the values in the Hash.
     * @return C++ vector of all the values in the Hash.
     */
    vector<FancyObject*> values();
  
    /**
     * Returns the size (amount of entries) in the Hash.
     * @return The size (amount of entries) in the Hash.
     */
    int size() const { return _mappings.size(); }

  private:
    map<FancyObject*, FancyObject*> _mappings;
  };

}

#endif /* _HASH_H_ */
