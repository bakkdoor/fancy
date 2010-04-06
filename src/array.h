#ifndef _ARRAY_H_
#define _ARRAY_H_

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

  bool operator==(const Array& other) const;
  virtual FancyObject_p equal(const FancyObject_p other) const;
  
  unsigned int size() const;
  void clear();
  list<FancyObject_p> to_list() const;

 private:
  vector<FancyObject_p> values;
};

typedef Array* Array_p;


#endif /* _ARRAY_H_ */
