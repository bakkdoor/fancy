#ifndef _STRING_H_
#define _STRING_H_

class String : public Object
{
 public:
  String(const string &value);
  ~String();

  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;
  string value() const;

 private:
  string _value;
};

typedef String* String_p;

#endif /* _STRING_H_ */
