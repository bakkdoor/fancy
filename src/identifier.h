#ifndef _IDENTIFIER_H_
#define _IDENTIFIER_H_

class Identifier : public Object
{
 public:
  Identifier(const string &name);
  ~Identifier();
  
  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;
  string name() const;

 private:
  string _name;
};

typedef Identifier* Identifier_p;


#endif /* _IDENTIFIER_H_ */
