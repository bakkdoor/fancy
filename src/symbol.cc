#include <string>

#include "symbol.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  Symbol::Symbol(const string &name) :
    FancyObject(SymbolClass), _name(name)
  {
  }

  FancyObject* Symbol::equal(FancyObject* other) const
  {
    if(!IS_SYMBOL(other)) {
      return nil;
    }
  
    Symbol* other_sym = dynamic_cast<Symbol*>(other);
    if(other_sym) {
      if(_name == other_sym->_name) {
        return t;
      }
    }
    return nil;
  }

  string Symbol::to_sexp() const
  {
    return "[:symbol_lit, " + _name + "]";
  }

  string Symbol::to_s() const
  {
    return _name.substr(1, _name.size() - 1);
  }

  map<string, Symbol*> Symbol::sym_cache;
  Symbol* Symbol::from_string(const string &name)
  {
    if(sym_cache.find(name) != sym_cache.end()) {
      return sym_cache[name];
    } else {
      // insert new name into sym_cache & return new number name
      Symbol* new_sym = new Symbol(name);
      sym_cache[name] = new_sym;
      return new_sym;
    }
  }

}
