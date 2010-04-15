#ifndef _ARRAY_H_
#define _ARRAY_H_

namespace fancy {

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
    Array();
    Array(int initial_size);
    Array(int initial_size, FancyObject_p initial_value);
    Array(array_node *val_list);
    Array(vector<FancyObject_p> list);
    ~Array();

    FancyObject_p operator[](int index) const;
    FancyObject_p at(unsigned int index) const;
    FancyObject_p set_value(unsigned int index, FancyObject_p value);
    FancyObject_p insert(FancyObject_p value);
    FancyObject_p insert_at(unsigned int index, FancyObject_p value);
    FancyObject_p append(Array *arr);
    FancyObject_p first() const;
    FancyObject_p last() const;

    virtual OBJ_TYPE type() const;
    virtual string to_s() const;
    virtual string inspect() const;

    bool operator==(const Array& other) const;
    virtual FancyObject_p equal(const FancyObject_p other) const;
  
    unsigned int size() const;
    void clear();
    Array* clone() const;
    list<FancyObject_p> to_list() const;
    vector<FancyObject_p> values() const;

  private:
    vector<FancyObject_p> _values;
  };

  typedef Array* Array_p;

}

#endif /* _ARRAY_H_ */
