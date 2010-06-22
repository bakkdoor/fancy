#ifndef _SCOPE_H_
#define _SCOPE_H_

#include <string>

#include "fancy_object.h"

using namespace std;

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

  typedef map<string, FancyObject*> object_map;

  class Scope : public gc_cleanup
  {
  public:
    Scope();
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
    virtual FancyObject* get(string identifier);

    /**
     * Defines an identifier with a value (or overwrites it, if already
     * defined).
     * @param identifier Identifier name
     * @param value Value for the identifier within the Scope.
     * @return True, if identifier was already defined (and thus, its
     * value overwritten).
     */
    virtual bool define(string identifier, FancyObject* value);

    /**
     * Sets the current_self value (reference to the 'self' value
     * within the Scope).
     * @param current_self New current_self value.
     */
    void set_current_self(FancyObject* current_self);

    /**
     * Returns the current_self value for the Scope.
     * @return The current_self value for the Scope.
     */
    FancyObject* current_self() const;

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
    void set_current_class(Class* klass);

    /**
     * Returns the Scope's parent scope or NULL, if not defined.
     * @return The Scope's parent scope or NULL.
     */
    Scope* parent_scope() const;

    void set_parent_scope(Scope* parent) { _parent = parent; }

    /**
     * Returns the value mappings map for the Scope.
     * @return The value mappings map for the Scope.
     */
    map<string, FancyObject*> value_mappings() const;

    /**
     * Sets the closed value for a Scope.
     * @param val The closed value (indicating, if the Scope has been
     * "closed over" by a LexicalScope).
     */
    void set_closed(bool val) { _closed = val; }

    /**
     * Indicates, if a Scope has been "closed over" by a LexicalScope.
     * @return True, if closed over by a LexicalScope, false otherwise.
     */
    bool is_closed() const { return _closed; }

    /**
     * Sets the current_sender Object for the Scope.
     * @param sender The current_sender Object.
     */
    void set_current_sender(FancyObject* sender) { _current_sender = sender; }

    /**
     * Returns the current_sender Object for the Scope.
     * @return The current_sender Object.
     */
    FancyObject* current_sender() const { return _current_sender; }

    void clear() { _value_mappings.clear(); }

  protected:
    map<string, FancyObject*> _value_mappings;
    Scope *_parent;
    FancyObject *_current_self;
    Class *_current_class;
    bool _closed;
    FancyObject* _current_sender;
  };

  /**
   * Global scope defined in src/main.c
   */
  extern Scope *global_scope;

}

#endif /* _SCOPE_H_ */
