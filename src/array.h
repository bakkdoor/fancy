#ifndef _ARRAY_H_
#define _ARRAY_H_

namespace fancy {

  /**
   * Linked-list node of values used in the parser.
   */
  struct array_node {
  public:
    FancyObject_p value;
    array_node *next;
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
    Array(int initial_size, FancyObject_p initial_value);

    /**
     * Initializes an Array via a array_node* linked list.
     * It gets used in the parser.
     * @param val_list array_node* linked list containing the values for the Array.
     */
    Array(array_node *val_list);

    /**
     * Initializes an Array with a given vector of values.
     * @param list Vector of values to take as the Arrays entries.
     */
    Array(vector<FancyObject_p> list);

    ~Array();

    /**
     * Returns element at a given index.
     * @param index The index
     * @return The value at the given or nil, if index invalid.
     */
    FancyObject_p operator[](int index) const;

    /**
     * Same as operator[].
     */
    FancyObject_p at(unsigned int index) const;

    /**
     * Sets a value at a given index.
     * @param index The index
     * @param value The value to set
     * @return The inserted value, if index is valid, nil otherwise.
     */
    FancyObject_p set_value(unsigned int index, FancyObject_p value);

    /**
     * Inserts a value at the end of the Array.
     * @param value The value to add.
     * @return The inserted value.
     */
    FancyObject_p insert(FancyObject_p value);

    /**
     * Same as set_value.
     * @return The inserted value.
     */
    FancyObject_p insert_at(unsigned int index, FancyObject_p value);

    /**
     * Appends another Array to this one.
     * @param arr Then Array to append.
     * @return Itself, including the appended elements.
     */
    FancyObject_p append(Array *arr);

    /**
     * Returns the first element in the Array.
     * @return First element in Array.
     */
    FancyObject_p first() const;

    /**
     * Returns the last element in the Array.
     * @return Last element in Array.
     */
    FancyObject_p last() const;

    virtual OBJ_TYPE type() const;
    virtual string to_s() const;
    virtual string inspect() const;

    /**
     * Compares two Arrays.
     * @param other Other Array to compare to.
     * @return true, if equal, false otherwise
     */
    bool operator==(const Array& other) const;
    virtual FancyObject_p equal(const FancyObject_p other) const;
  
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
    list<FancyObject_p> to_list() const;

    /**
     * Returns vector of elements in Array.
     * @return Vector of elements in Array.
     */
    vector<FancyObject_p> values() const;

  private:
    vector<FancyObject_p> _values;
  };

  typedef Array* Array_p;

}

#endif /* _ARRAY_H_ */
