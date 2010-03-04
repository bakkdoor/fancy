#ifndef _REGEX_H_
#define _REGEX_H_

class Regex : public NativeObject
{
 public:
  Regex(const string &pattern);
  ~Regex();
  
  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual string to_s() const;
  string pattern() const;
  NativeObject_p match(String_p string) const;

 private:
  string _pattern;
};

typedef Regex* Regex_p;

#endif /* _REGEX_H_ */
