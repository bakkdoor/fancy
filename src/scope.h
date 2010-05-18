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
    bool define(string identifier, FancyObject_p value);

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;

    void set_current_self(FancyObject_p current_self);
    FancyObject_p current_self() const;

    Class* current_class() const;
    void set_current_class(Class_p klass);

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
