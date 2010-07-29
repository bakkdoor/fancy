#ifndef _CLASS_H_
#define _CLASS_H_

#include <vector>
#include <set>
#include <map>
#include <string>

#include "fancy_object.h"

using namespace std;


namespace fancy {

  /**
   * Represents Classes within Fancy.
   * Inherits form FancyObject since Classes are Objects in Fancy (and
   * are instances of the Class Class).
   */
  class Class : public FancyObject
  {
  public:
    /**
     * Initializes Anonymous Class with a given superclass.
     * @param superclass Superclass of the Class.
     */
    Class(Class* superclass);

    /**
     * Initializes Class with a given name.
     * @param name Name of the class.
     */
    Class(const string &name);

    /**
     * Initializes Class with a given name and a superclass.
     * @param name Name of the class.
     * @param superclass Superclass of the Class.
     */
    Class(const string &name, Class* superclass);

    virtual ~Class();

    /**
     * Returns the name of the Class.
     * @return Name of the Class.
     */
    string name() const { return _name; }

    /**
     * Creates an instance of the Class.
     * @return New instance of the Class.
     */
    FancyObject* create_instance() const;

    /**
     * Defines an instance slot for a class.
     * @param name Name of the slot.
     */
    void def_slot(const string &name);

    /**
     * Defines a class slot for the class with a given value.
     * @param name The name of the class slot.
     * @param value The value for the class slot.
     */
    void def_class_slot(const string &name, FancyObject* value);

    /**
     * Returns the value of a class slot.
     * @param identifier Name of the class slot.
     * @return The value of the class slot (or nil, if not defined).
     */
    FancyObject* get_class_slot(const string &identifier) const;

    /**
     * Defines an instance method for the class.
     * @param name the name of the instance method.
     * @param method The instance method object.
     */
    void def_method(const string &name, Callable* method);

    /**
     * Undefines an existing instance method within the class.
     * @param name the name of the instance method to be deleted
     * (undefined).
     * @return true, if method existed, false otherwise.
     */
    bool undef_method(const string &name);

    /**
     * Defines a private instance method for the class.
     * @param name the name of the private instance method.
     * @param method The instance method object.
     */
    void def_private_method(const string &name, Callable* method);

    /**
     * Defines a protected instance method for the class.
     * @param name the name of the protected instance method.
     * @param method The instance method object.
     */
    void def_protected_method(const string &name, Callable* method);

    /**
     * Defines a class method for the Class.
     * Note: This is the same as calling Class#def_singleton_method
     * since class methods are simply singleton methods on Class objects.
     * @param name Name of the class method.
     * @param method The class method object.
     */
    void def_class_method(const string &name, Callable* method);

    /**
     * Undefines an existing class method within the class.
     * @param name the name of the class method to be deleted
     * (undefined).
     * @return true, if method existed, false otherwise.
     */
    bool undef_class_method(const string &name);

    /**
     * Defines a private class method for the Class.
     * Note: This is the same as calling Class#def_private_singleton_method
     * since class methods are simply singleton methods on Class objects.
     * @param name Name of the private class method.
     * @param method The private class method object.
     */
    void def_private_class_method(const string &name, Callable* method);

    /**
     * Defines a protected class method for the Class.
     * Note: This is the same as calling Class#def_protected_singleton_method
     * since class methods are simply singleton methods on Class objects.
     * @param name Name of the protected class method.
     * @param method The protected class method object.
     */
    void def_protected_class_method(const string &name, Callable* method);

    /**
     * Includes (Mixin) another the methods of another Class into this one.
     * @param klass The other class to mix-in.
     */
    void include(Class* klass);

    /**
     * Returns a vector of the names of the instance slots.
     * @return Vector of the names of the instance slots.
     */
    vector<string> instance_slotnames() const { return _instance_slotnames; }

    /**
     * Returns a map of the names and values of the class slots.
     * @return Map of the names and values of the class slots.
     */
    map<string, FancyObject*> class_slots() const { return _class_slots; }

    virtual FancyObject* equal(FancyObject* other) const;
    virtual EXP_TYPE type() const { return EXP_CLASS; }
    virtual string to_s() const { return _name; }

    /**
     * Look-up method for finding a method in the Class.
     * @param name Name of the method to find.
     * @return A Callable representing the method or NULL, if method isn't found.
     */
    Callable* find_method(const string &name);

    /**
     * Look-up method for finding a method withing this Class.
     * If this class does not have this method defined (e.g. only
     * defined in superclass) return NULL.
     * @param name Name of the method to find within the Class.
     * @return A Callable representing the method or NULL, if method
     * not defined in Class.
     */
    Callable* find_method_in_class(const string &name);

    /**
     * Indicates, if a Class is a subclass of a given Class (or the same).
     * @param klass The class to check.
     * @return true, if this Class is a subclass of the given class, false otherwise.
     */
    bool subclass_of(Class* klass);

    /**
     * Returns the Superclass of this Class (if there is one).
     * @return The Superclass of this Class (or NULL).
     */
    Class* superclass() const;

    /**
     * Returns an Array with all instance methods defined for this Class.
     * @return Array with all instance methods defined for this Class.
     */
    Array* instance_methods() const;

    /**
     * Adds a nested Class to this Class.
     * @param class_name Name of the nested Class.
     * @param klass The Class to be nested into this one.
     */
    void add_nested_class(const string &class_name, Class* klass);

    /**
     * Returns the nested Class object or NULL, if not defined.
     * @param class_name Name of the nested Class.
     * @return The nested Class or NULL, if not defined.
     */
    Class* get_nested_class(const string &class_name) const;

    /**
     * Returns the nested Classes of a Class as a vector of FancyObjects.
     * @return The nested Classes of a Class as a vector of FancyObjects.
     */
    vector<FancyObject*> nested_classes() const;

  private:
    string _name;
    vector<string> _instance_slotnames;
    map<string, FancyObject*> _class_slots;
    Class* _superclass;
    set<Class*> _included_classes;
    map<string, Callable*> _instance_methods;
    map<string, Class*> _nested_classes;
  };

}

#endif /* _CLASS_H_ */
