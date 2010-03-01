#ifndef _ARRAY_H_
#define _ARRAY_H_

struct array_node {
public:
  Object_p value;
  array_node *next;
};

class Array : public Object
{
 public:
  Array(array_node *val_list);
  Array(vector<Object_p> list);
  Array(list<Expression_p> expressions);
  ~Array();

  Object_p operator[](int index) const;
  Object_p at(unsigned int index) const;
  Object_p set_value(unsigned int index, Object_p value);
  Object_p insert(Object_p value);
  Object_p insert_at(unsigned int index, Object_p value);
  Object_p append(Array *arr);
  Object_p first() const;
  Object_p last() const;

  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;

  bool operator==(const Array& other) const;
  virtual Object_p equal(const Object_p other) const;
  
  int size() const;

 private:
  vector<Object_p> values;
  bool unevaled;
  list<Expression_p> expressions;
};

typedef Array* Array_p;


#endif /* _ARRAY_H_ */
