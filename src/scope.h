#ifndef _SCOPE_H_
#define _SCOPE_H_

/**
 * A scope contains a hashtable, in which all identifiers etc. are
 * stored, as well as a potential reference to its parent scope.
 *
 * For example, a function scope has a reference to a parent scope
 * (the scope, in which the function is defined).
 */

class Scope : public gc_cleanup
{
 public:
  Scope();

  /**
   * Creates a new scope with a given parent scope.
   * @param parent The parent scope of the new scope. Can be NULL, if no
   * parent exists.
   * @return The newly created scope.
   */
  Scope(Scope *parent);
  ~Scope();

  /**
   * Looks for an identifier and returns the corresponding object, if in
   * scope (or in parent scope, if a parent is set).
   * @param identifier The identifier string.
   * @return The (value) object represented by the identifier within the
   * scope
   */
  Object_p operator[](string identifier) const;

  bool define(string identifier, Object_p value);

  void def_builtin(string identifier,
                   Object_p (&func)(Object_p args, Scope *sc),
                   unsigned int n_args);

  void def_builtin(Identifier_p identifier,
                   Object_p (&func)(Object_p args, Scope *sc),
                   unsigned int n_args);

  void def_builtin_special(string identifier,
                           Object_p (&func)(Object_p args, Scope *sc),
                           unsigned int n_args);
  
  Object_p get(string identifier);
  BuiltinMethod_p get_builtin(string identifier);

  string to_s() const;
  int size() const;

 private:
  map<string, BuiltinMethod_p> builtin_mappings;
  map<string, Object_p> value_mappings;
  Scope *parent;
};

/**
 * Global scope defined in src/main.c
 */
extern Scope *global_scope;

/**
 * Sets up the global scope with predefined functions etc.
 */
void init_global_scope();

#endif /* _SCOPE_H_ */
