#ifndef _STRING_H_
#define _STRING_H_

class String;
typedef String* String_p;

class String : public NativeObject
{
 public:
  String(const string &value);
  ~String();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual string to_s() const;
  string value() const;

  static String_p from_value(const string &value);

 private:
  string _value;

  static map<string, String_p> value_cache;
};

#endif /* _STRING_H_ */
