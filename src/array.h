#ifndef _ARRAY_H_
#define _ARRAY_H_

struct array_node {
public:
  NativeObject_p value;
  array_node *next;
};

class Array : public NativeObject
{
 public:
  Array(array_node *val_list);
  Array(vector<NativeObject_p> list);
  Array(list<Expression_p> expressions);
  ~Array();

  NativeObject_p operator[](int index) const;
  NativeObject_p at(unsigned int index) const;
  NativeObject_p set_value(unsigned int index, NativeObject_p value);
  NativeObject_p insert(NativeObject_p value);
  NativeObject_p insert_at(unsigned int index, NativeObject_p value);
  NativeObject_p append(Array *arr);
  NativeObject_p first() const;
  NativeObject_p last() const;

  virtual FancyObject_p eval(Scope *scope);
  virtual string to_s() const;

  bool operator==(const Array& other) const;
  virtual NativeObject_p equal(const NativeObject_p other) const;
  
  int size() const;

 private:
  vector<NativeObject_p> values;
  bool unevaled;
  list<Expression_p> expressions;
};

typedef Array* Array_p;


#endif /* _ARRAY_H_ */
