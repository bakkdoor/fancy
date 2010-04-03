#ifndef _SYMBOL_H_
#define _SYMBOL_H_

class Symbol;
typedef Symbol* Symbol_p;

class Symbol : public FancyObject
{
 public:
  Symbol(const string &name);
  ~Symbol();
  
  virtual FancyObject_p equal(const FancyObject_p other) const;
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;
  string name() const;

  static Symbol_p from_string(const string &name);

 private:
  string _name;

  static map<string, Symbol_p> sym_cache;
};


#endif /* _SYMBOL_H_ */
