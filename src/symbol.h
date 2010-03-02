#ifndef _SYMBOL_H_
#define _SYMBOL_H_

class Symbol;
typedef Symbol* Symbol_p;

class Symbol : public Object
{
 public:
  Symbol(const string &name);
  ~Symbol();
  
  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;
  string name() const;

  static Symbol_p from_string(const string &name);

 private:
  string _name;

  static map<string, Symbol_p> sym_cache;
};


#endif /* _SYMBOL_H_ */
