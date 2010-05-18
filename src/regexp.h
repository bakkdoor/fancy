#ifndef _REGEX_H_
#define _REGEX_H_

namespace fancy {

  /**
   * Regexpp class representing Regular Expression Objects in Fancy.
   */
  class Regexp : public FancyObject
  {
  public:
    /**
     * Regexp constructor.
     * @param pattern A C++ string that is the regexp pattern.
     */
    Regexp(const string &pattern);
    ~Regexp();

    /**
     * See FancyObject for these methods.
     */  
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;

    /**
     * Returns the pattern string.
     * @return C++ pattern string.
     */
    string pattern() const;

    /**
     * Does the matching on a given string.
     * @param string The string to match this regular expression
     * against.
     * @return The match value (e.g. nil, if none match or the array
     * with matches).
     */
    FancyObject_p match(String_p string) const;

  private:
    string _pattern;
  };

  typedef Regexp* Regexp_p;

}

#endif /* _REGEX_H_ */
