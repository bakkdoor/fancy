#ifndef _SCOPE_H_
#define _SCOPE_H_

namespace fancy {

  /**
   * A scope contains a hashtable, in which all identifiers etc. are
   * stored, as well as a potential reference to its parent scope.
   *
   * For example, a function scope has a reference to a parent scope
   * (the scope, in which the function is defined).
   */

  class Class;
  class FancyObject;

  typedef map<string, FancyObject_p> object_map;

  class Scope : public FancyObject
  {
  public:
    Scope(FancyObject *current_self);
    Scope(Scope *parent);

    /**
     * Creates a new scope with a given parent scope.
     * @param current_self The value for self within the scope.
     * @param parent The parent scope of the new scope. Can be NULL, if no
     * parent exists.
     * @return The newly created scope.
     */
    Scope(FancyObject *current_self, Scope *parent);
    ~Scope();

    /**
     * Looks for an identifier and returns the corresponding object,
     * if in scope (or in parent scope, if a parent is set).
     * @param identifier The identifier string.
     * @return The (value) object represented by the identifier within
     * the scope
     */
    FancyObject_p get(string identifier);

    /**
     * Defines an identifier with a value (or overwrites it, if already
     * defined).
     * @param identifier Identifier name
     * @param value Value for the identifier within the Scope.
     * @return True, if identifier was already defined (and thus, its
     * value overwritten).
     */
    bool define(string identifier, FancyObject_p value);

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual EXP_TYPE type() const;
    virtual string to_s() const;

    /**
     * Sets the current_self value (reference to the 'self' value
     * within the Scope).
     * @param current_self New current_self value.
     */
    void set_current_self(FancyObject_p current_self);

    /**
     * Returns the current_self value for the Scope.
     * @return The current_self value for the Scope.
     */
    FancyObject_p current_self() const;

    /**
     * Returns the current_class value for the Scope.
     * @return The current_class value for the Scope.
     */
    Class* current_class() const;

    /**
     * Sets the current_class value (reference to the current class
     * within the Scope).
     * @param klass New current_class value.
     */
    void set_current_class(Class_p klass);

    /**
     * Returns the Scope's parent scope or NULL, if not defined.
     * @return The Scope's parent scope or NULL.
     */
    Scope* parent_scope() const;

  private:
    map<string, FancyObject_p> _value_mappings;
    Scope *_parent;
    FancyObject *_current_self;
    Class *_current_class;
  };

  /**
   * Global scope defined in src/main.c
   */
  extern Scope *global_scope;

}

#endif /* _SCOPE_H_ */
