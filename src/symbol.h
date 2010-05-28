#ifndef _SYMBOL_H_
#define _SYMBOL_H_

namespace fancy {

  class Symbol;
  typedef Symbol* Symbol_p;

  /**
   * Symbol class representing Symbol objects in Fancy.
   * A Symbol is an identifier, starting with a colon (':').
   * Examples: :foo, :bar, :baz
   */
  class Symbol : public FancyObject
  {
  public:
    /**
     * Symbol constructor.
     * @param name Name of the Symbol.
     */
    Symbol(const string &name);
    ~Symbol();
  
    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual EXP_TYPE type() const;
    virtual string to_s() const;
    virtual string inspect() const;

    /**
     * Returns the name of the Symbol (as a C++ string).
     * @return The name of the Symbol (as a C++ string).
     */
    string name() const;

    /**
     * Returns a Symbol object with a given name.
     * Symbols in Fancy get cached, since they're immutable.
     * Multiple occurances of the same Symbol in Fancy use the same
     * Symbol object.
     * @param value C++ string for the name.
     * @return A Symbol object with a given name.
     */
    static Symbol_p from_string(const string &name);

  private:
    string _name;

    static map<string, Symbol_p> sym_cache;
  };

}

#endif /* _SYMBOL_H_ */
