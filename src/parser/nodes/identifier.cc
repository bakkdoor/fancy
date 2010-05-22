#include "includes.h"

namespace fancy {
  namespace parser {
    namespace nodes {

      Identifier::Identifier(const string &name) :
        _name(name)
      {
      }

      Identifier::~Identifier()
      {
      }

      FancyObject_p Identifier::eval(Scope *scope)
      {
        return scope->get(_name);
      }

      OBJ_TYPE Identifier::type() const
      {
        return OBJ_IDENTIFIER;
      }

      string Identifier::name() const
      {
        return _name;
      }

      map<string, Identifier_p> Identifier::ident_cache;
      Identifier_p Identifier::from_string(const string &name)
      {
        if(ident_cache.find(name) != ident_cache.end()) {
          return ident_cache[name];
        } else {
          // insert new name into ident_cache & return new number name
          Identifier_p new_ident = new Identifier(name);
          ident_cache[name] = new_ident;
          return new_ident;
        }
      }

    }
  }
}
