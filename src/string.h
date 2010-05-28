#ifndef _STRING_H_
#define _STRING_H_

namespace fancy {

  class String;
  typedef String* String_p;

  /**
   * String class representing String objects within Fancy.
   */
  class String : public FancyObject
  {
  public:
    /**
     * String constructor.
     * @param value C++ string containing the actual string.
     */
    String(const string &value);
    ~String();

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual EXP_TYPE type() const;
    virtual string to_s() const;
    virtual string inspect() const;

    /**
     * Returns the C++ string value.
     * @return The C++ string value.
     */
    string value() const;

    /**
     * Replaces all occurences of what in the String with with.
     * @param what String to find and replace.
     * @param with String to replace all occurrances of what with.
     */
    void replace(string &what, string &with);

    /**
     * Returns a String object with a given C++ string value.
     * Strings in Fancy get cached, since they're immutable.
     * Multiple occurances of the same String in Fancy use the same
     * String object.
     * @param value C++ string value.
     * @return A String object with a given C++ string value.
     */
    static String_p from_value(const string &value);

  private:
    string _value;

    static map<string, String_p> value_cache;
  };

}

#endif /* _STRING_H_ */
