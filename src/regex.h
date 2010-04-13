#ifndef _REGEX_H_
#define _REGEX_H_

namespace fancy {

  class Regex : public FancyObject
  {
  public:
    Regex(const string &pattern);
    ~Regex();
  
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;
    string pattern() const;
    FancyObject_p match(String_p string) const;

  private:
    string _pattern;
  };

  typedef Regex* Regex_p;

}

#endif /* _REGEX_H_ */
