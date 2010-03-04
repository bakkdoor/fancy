#include "includes.h"

Array::Array(array_node *val_list) : NativeObject(OBJ_ARRAY)
{
  for(array_node *tmp = val_list; tmp; tmp = tmp->next) {
    if(tmp->value)
      this->values.push_back(tmp->value);
  }
  this->unevaled = false;
}

Array::Array(vector<NativeObject_p> list) :
  NativeObject(OBJ_ARRAY), values(list)
{
  // copy elements of given list
  this->unevaled = false;
}

Array::Array(list<Expression_p> expressions) :
  NativeObject(OBJ_ARRAY), expressions(expressions)
{
  this->unevaled = true;
}

Array::~Array() 
{
}

NativeObject_p Array::operator[](int index) const
{
  return this->at(index);
}

NativeObject_p Array::at(unsigned int index) const
{
  if(index < this->values.size()) {
    return this->values[index];
  } else {
    return nil;
  }
}

NativeObject_p Array::set_value(unsigned int index, NativeObject_p value)
{
  if(index < this->values.size()) {
    this->values[index] = value;
    return value;
  } else {
    return nil;
  }
}

NativeObject_p Array::insert(NativeObject_p value)
{
  this->values.push_back(value);
  return value;
}

NativeObject_p Array::insert_at(unsigned int index, NativeObject_p value)
{
  this->set_value(index, value);
  return value;
}

NativeObject_p Array::append(Array_p arr)
{
  vector<NativeObject_p>::iterator it;
  for(it = arr->values.begin(); it < arr->values.end(); it++) {
    this->values.push_back(*it);
  }
  return this;
}

NativeObject_p Array::first() const
{
  if(this->values.size() > 0) {
    return this->values.front();
  } else {
    return nil;
  }
}

NativeObject_p Array::last() const
{
  if(this->values.size() > 0) {
    return this->values.back();
  } else {
    return nil;
  }
}

FancyObject_p Array::eval(Scope *scope)
{
  if(!this->unevaled) {
    return ArrayClass->create_instance(this);
  } else {
    // eval all expressions and save them to values
    list<Expression_p>::iterator it;
    for(it = this->expressions.begin(); it != this->expressions.end(); it++) {
      this->values.push_back((*it)->eval(scope));
    }
    return ArrayClass->create_instance(this);
  }
}

string Array::to_s() const
{
  stringstream s;
  s << "[";
  for(unsigned int i = 0; i < this->values.size(); i++) {
    s << this->values[i]->to_s();
    if(i != (this->values.size() - 1)) {
      s << ", ";
    }
  }
  s << "]";
  return s.str();
}

bool Array::operator==(const Array& other) const
{
  if(this->values.size() != other.values.size())
    return false;

  for(unsigned int i = 0; i < this->values.size(); i++) {
    if(this->values[i]->equal(other.values[i]) == nil) {
      return false;
    }
  }
  return true;
}

NativeObject_p Array::equal(const NativeObject_p other) const
{
  if(other->type() != OBJ_ARRAY)
    return nil;

  Array_p other_array = (Array_p)other;
  if((*this) == (*other_array))
    return t;
  return nil;
}

int Array::size() const
{
  return this->values.size();
}
