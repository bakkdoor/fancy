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
     * Looks for an identifier and returns the corresponding object, if in
     * scope (or in parent scope, if a parent is set).
     * @param identifier The identifier string.
     * @return The (value) object represented by the identifier within the
     * scope
     */
    FancyObject_p operator[](string identifier) const;

    bool define(string identifier, FancyObject_p value);

    void def_native(string identifier,
                    FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *sc),
                    unsigned int n_args);

    void def_native(Identifier_p identifier,
                    FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *sc),
                    unsigned int n_args);

    void def_native_special(string identifier,
                            FancyObject_p (&func)(FancyObject_p self, list<FancyObject_p> args, Scope *sc),
                            unsigned int n_args);
  
    FancyObject_p get(string identifier);
    NativeMethod_p get_native(string identifier);

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;
    int size() const;

    void set_current_self(FancyObject_p current_self);
    FancyObject_p current_self() const;
    Class* current_class() const;

    void set_current_class(Class_p klass);
  
    Scope* parent_scope() const;

  private:
    map<string, NativeMethod_p> builtin_mappings;
    map<string, FancyObject_p> value_mappings;
    Scope *parent;
    FancyObject *_current_self;
    Class *_current_class;
  };

  /**
   * Global scope defined in src/main.c
   */
  extern Scope *global_scope;

}

#endif /* _SCOPE_H_ */
