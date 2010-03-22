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
  Array();
  Array(array_node *val_list);
  Array(expression_node *expr_list);
  Array(vector<FancyObject_p> list);
  Array(list<Expression_p> expressions);
  ~Array();

  FancyObject_p operator[](int index) const;
  FancyObject_p at(unsigned int index) const;
  FancyObject_p set_value(unsigned int index, FancyObject_p value);
  FancyObject_p insert(FancyObject_p value);
  FancyObject_p insert_at(unsigned int index, FancyObject_p value);
  FancyObject_p append(Array *arr);
  FancyObject_p first() const;
  FancyObject_p last() const;

  virtual FancyObject_p eval(Scope *scope);
  virtual string to_s() const;

  bool operator==(const Array& other) const;
  virtual NativeObject_p equal(const NativeObject_p other) const;
  
  unsigned int size() const;

 private:
  vector<FancyObject_p> values;
  bool unevaled;
  list<Expression_p> expressions;
};

typedef Array* Array_p;


#endif /* _ARRAY_H_ */
