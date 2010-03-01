#ifndef _STRING_H_
#define _STRING_H_

class String;
typedef String* String_p;

class String : public Object
{
 public:
  String(const string &value);
  ~String();

  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;
  string value() const;

  static String_p from_value(const string &value);

 private:
  string _value;

  static map<string, String_p> value_cache;
};

#endif /* _STRING_H_ */
