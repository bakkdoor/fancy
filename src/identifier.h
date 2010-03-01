#ifndef _IDENTIFIER_H_
#define _IDENTIFIER_H_

class Identifier;
typedef Identifier* Identifier_p;

class Identifier : public Object
{
 public:
  Identifier(const string &name);
  ~Identifier();
  
  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;
  string name() const;

  static Identifier_p from_string(const string &name);

 private:
  string _name;

  static map<string, Identifier_p> ident_cache;
};

#endif /* _IDENTIFIER_H_ */
