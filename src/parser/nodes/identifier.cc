#include "identifier.h"
#include "../../scope.h"

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

      FancyObject* Identifier::eval(Scope *scope)
      {
        return scope->get(_name);
      }

      EXP_TYPE Identifier::type() const
      {
        return EXP_IDENTIFIER;
      }

      string Identifier::name() const
      {
        return _name;
      }

      map<string, Identifier*> Identifier::ident_cache;
      Identifier* Identifier::from_string(const string &name)
      {
        if(ident_cache.find(name) != ident_cache.end()) {
          return ident_cache[name];
        } else {
          // insert new name into ident_cache & return new number name
          Identifier* new_ident = new Identifier(name);
          ident_cache[name] = new_ident;
          return new_ident;
        }
      }

    }
  }
}
