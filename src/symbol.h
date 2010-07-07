#ifndef _SYMBOL_H_
#define _SYMBOL_H_

#include "fancy_object.h"

namespace fancy {

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
    ~Symbol() {}
  
    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject* equal(FancyObject* other) const;
    virtual EXP_TYPE type() const { return EXP_SYMBOL; }
    virtual string to_sexp() const;
    virtual string to_s() const;
    virtual string inspect() const { return _name; }

    /**
     * Returns the name of the Symbol (as a C++ string).
     * @return The name of the Symbol (as a C++ string).
     */
    string name() const { return _name; }

    /**
     * Returns a Symbol object with a given name.
     * Symbols in Fancy get cached, since they're immutable.
     * Multiple occurances of the same Symbol in Fancy use the same
     * Symbol object.
     * @param value C++ string for the name.
     * @return A Symbol object with a given name.
     */
    static Symbol* from_string(const string &name);

  private:
    string _name;

    static map<string, Symbol*> sym_cache;
  };

}

#endif /* _SYMBOL_H_ */
