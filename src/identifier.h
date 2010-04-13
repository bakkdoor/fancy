#ifndef _IDENTIFIER_H_
#define _IDENTIFIER_H_

namespace fancy {

  class Identifier;
  typedef Identifier* Identifier_p;

  class Identifier : public Expression
  {
  public:
    Identifier(const string &name);
    ~Identifier();
  
    virtual FancyObject_p eval(Scope *scope);
    virtual OBJ_TYPE type() const;
    string name() const;

    static Identifier_p from_string(const string &name);

  private:
    string _name;

    static map<string, Identifier_p> ident_cache;
  };

}

#endif /* _IDENTIFIER_H_ */
