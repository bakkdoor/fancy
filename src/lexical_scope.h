#ifndef _LEXICAL_SCOPE_H_
#define _LEXICAL_SCOPE_H_

#include <string>

#include "scope.h"

using namespace std;

namespace fancy {

  /**
   * A LexicalScope is a special kind of Scope used within Blocks.
   * They might define a given value for an identifier within another
   * Scope up the call environment in order to support lexical closure
   * semantics.
   */
  class LexicalScope : public Scope
  {
  public:
    /**
     * Initializes a LexicalScope with a given parent Scope.
     * @param scope The LexicalScope's parent Scope.
     */
    LexicalScope(Scope *scope);
    virtual ~LexicalScope() {}

    /**
     * Defines a value for a given name within the LexicalScope.
     * Note: LexicalScopes differ from normal Scopes, in that they
     * might store the value within another Scope in which an
     * identifier is already defined (lexically).
     * @param identifier Identifier name.
     * @param value Value for the identifier within the Scope.
     * @return True, if identifier was already defined (and thus, its
     * value overwritten).
     */
    virtual bool define(string identifier, FancyObject* value);

  private:
    /**
     * Returns the nearest Scope in the call environment that has a
     * given identifier defined, or returns NULL.
     * @param identifier Identifier to check for.
     * @return Scope that has the identifier defined, or NULL.
     */
    Scope* scope_for_ident(const string &identifier);
  };

}
#endif /* _LEXICAL_SCOPE_H_ */
