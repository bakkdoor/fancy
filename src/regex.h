#ifndef _REGEX_H_
#define _REGEX_H_

class Regex : public Object
{
 public:
  Regex(const string &pattern);
  ~Regex();
  
  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;
  string pattern() const;
  Object_p match(String_p string) const;

 private:
  string _pattern;
};

typedef Regex* Regex_p;

#endif /* _REGEX_H_ */
