#ifndef _FANCY_STRING_H_
#define _FANCY_STRING_H_

#include "fancy_object.h"


namespace fancy {

  /**
   * String class representing String objects within Fancy.
   */
  class FancyString : public FancyObject
  {
  public:
    /**
     * FancyString constructor.
     * @param value C++ string containing the actual string.
     */
    FancyString(const string &value);
    ~FancyString();

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject* equal(FancyObject* other) const;
    virtual EXP_TYPE type() const;
    virtual string to_s() const;
    virtual string inspect() const;

    /**
     * Returns the C++ string value.
     * @return The C++ string value.
     */
    string value() const;

    /**
     * Replaces all occurences of what in the FancyString with with.
     * @param what FancyString to find and replace.
     * @param with FancyString to replace all occurrances of what with.
     */
    void replace(string &what, string &with);

    /**
     * Returns a FancyString object with a given C++ string value.
     * FancyStrings in Fancy get cached, since they're immutable.
     * Multiple occurances of the same FancyString in Fancy use the same
     * FancyString object.
     * @param value C++ string value.
     * @return A FancyString object with a given C++ string value.
     */
    static FancyString* from_value(const string &value);

  private:
    string _value;

    static map<string, FancyString*> value_cache;
  };

}

#endif /* _FANCY_STRING_H_ */
