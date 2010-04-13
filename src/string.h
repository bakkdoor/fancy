#ifndef _STRING_H_
#define _STRING_H_

namespace fancy {

  class String;
  typedef String* String_p;

  class String : public FancyObject
  {
  public:
    String(const string &value);
    ~String();

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;
    virtual string inspect() const;
    string value() const;

    static String_p from_value(const string &value);

  private:
    string _value;

    static map<string, String_p> value_cache;
  };

}

#endif /* _STRING_H_ */
