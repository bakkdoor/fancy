#include "lexical_scope.h"

namespace fancy {

  LexicalScope::LexicalScope(Scope* scope) :
    Scope(scope->current_self(), scope)
  {
    scope->set_closed(true);
  }

  LexicalScope::~LexicalScope()
  {
  }

  bool LexicalScope::define(string identifier, FancyObject* value)
  {
    if(Scope* the_scope = scope_for_ident(identifier)) {
      if(the_scope != this) {
        return the_scope->define(identifier, value);
      } else {
        return Scope::define(identifier, value);
      }
    } else {
      return Scope::define(identifier, value);
    }
  }

  Scope* LexicalScope::scope_for_ident(const string &identifier)
  {
    Scope* the_scope = this;
    while(the_scope) {
      map<string, FancyObject*> mappings = the_scope->value_mappings();
      if(mappings.find(identifier) != mappings.end()) {
        return the_scope;
      }
      the_scope = the_scope->parent_scope();
    }
    return NULL;
  }
}

