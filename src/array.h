#ifndef _ARRAY_H_
#define _ARRAY_H_

#include <list>
#include <vector>

#include "fancy_object.h"
#include "scope.h"

using namespace std;

namespace fancy {

  /**
   * Linked-list node of values used in the parser.
   */
  struct array_node {
  public:
    FancyObject* value;
    array_node* next;
  };

  /**
   * Array class for native values of ArrayClass instances within Fancy.
   * Internally, a std::vector is used for fast index-based access.
   */
  class Array : public FancyObject
  {
  public:
    /**
     * Initializes an empty Array.
     */
    Array();

    /**
     * Initializes an Array with a given size, each entry being set to nil.
     * @param initial_size Initial size of the Array.
     */
    Array(int initial_size);

    /**
     * Initializes an Array with a given size, each entry being set to a given initial_value.
     * @param initial_size Initial size of the Array.
     * @param initial_value Initial value for all elements in the Array.
     */
    Array(int initial_size, FancyObject* initial_value);

    /**
     * Initializes an Array via a array_node* linked list.
     * It gets used in the parser.
     * @param val_list array_node* linked list containing the values for the Array.
     */
    Array(array_node* val_list);

    /**
     * Initializes an Array with a given vector of values.
     * @param list Vector of values to take as the Arrays entries.
     */
    Array(vector<FancyObject*> list);

    ~Array();

    /**
     * Returns element at a given index.
     * @param index The index
     * @return The value at the given or nil, if index invalid.
     */
    FancyObject* operator[](int index) const;

    /**
     * Same as operator[].
     */
    FancyObject* at(int index) const;

    /**
     * Sets a value at a given index.
     * @param index The index
     * @param value The value to set
     * @return The inserted value, if index is valid, nil otherwise.
     */
    FancyObject* set_value(unsigned int index, FancyObject* value);

    /**
     * Inserts a value at the end of the Array.
     * @param value The value to add.
     * @return The inserted value.
     */
    FancyObject* insert(FancyObject* value);

    /**
     * Same as set_value.
     * @return The inserted value.
     */
    FancyObject* insert_at(unsigned int index, FancyObject* value);

    /**
     * Removes (deletes) an entry at the given index.
     * @param index The index where to delete the value at.
     * @return The deleted value.
     */
    FancyObject* remove_at(int index);

    /**
     * Appends another Array to this one.
     * @param arr Then Array to append.
     * @return Itself, including the appended elements.
     */
    FancyObject* append(Array *arr);

    /**
     * Returns the first element in the Array.
     * @return First element in Array.
     */
    FancyObject* first() const;

    /**
     * Returns the last element in the Array.
     * @return Last element in Array.
     */
    FancyObject* last() const;

    /**
     * Returns the last n elements in the Array.
     * @return Last n elements in Array.
     */
    Array* last(int n) const;

    virtual EXP_TYPE type() const { return EXP_ARRAY; }
    virtual string to_s() const;
    virtual string inspect() const;
  
    /**
     * Returns size of Array.
     * @return Size of Array.
     */
    unsigned int size() const;

    /**
     * Removes all elements from Array in place.
     */
    void clear();

    /**
     * Clones Array.
     * @return New Array containing all elements of this array.
     */
    Array* clone() const;

    /**
     * Returns list of elements in Array.
     * @return List of elements in Array.
     */
    list<FancyObject*> to_list() const;

    /**
     * Returns vector of elements in Array.
     * @return Vector of elements in Array.
     */
    vector<FancyObject*> values() const { return _values; }

  private:
    vector<FancyObject*> _values;
  };

}

#endif /* _ARRAY_H_ */
