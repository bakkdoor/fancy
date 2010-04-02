#include "includes.h"

Array::Array() : FancyObject(ArrayClass)
{
}

Array::Array(array_node *val_list) : FancyObject(ArrayClass)
{
  for(array_node *tmp = val_list; tmp; tmp = tmp->next) {
    if(tmp->value)
      this->values.push_back(tmp->value);
  }
}

Array::Array(vector<FancyObject_p> list) :
  FancyObject(ArrayClass), values(list)
{
}

Array::~Array() 
{
}

FancyObject_p Array::operator[](int index) const
{
  return this->at(index);
}

FancyObject_p Array::at(unsigned int index) const
{
  if(index < this->values.size()) {
    return this->values[index];
  } else {
    return nil;
  }
}

FancyObject_p Array::set_value(unsigned int index, FancyObject_p value)
{
  if(index < this->values.size()) {
    this->values[index] = value;
    return value;
  } else {
    return nil;
  }
}

FancyObject_p Array::insert(FancyObject_p value)
{
  this->values.push_back(value);
  return value;
}

FancyObject_p Array::insert_at(unsigned int index, FancyObject_p value)
{
  this->set_value(index, value);
  return value;
}

FancyObject_p Array::append(Array_p arr)
{
  vector<FancyObject_p>::iterator it;
  for(it = arr->values.begin(); it < arr->values.end(); it++) {
    this->values.push_back(*it);
  }
  return this;
}

FancyObject_p Array::first() const
{
  if(this->values.size() > 0) {
    return this->values.front();
  } else {
    return nil;
  }
}

FancyObject_p Array::last() const
{
  if(this->values.size() > 0) {
    return this->values.back();
  } else {
    return nil;
  }
}

OBJ_TYPE Array::type() const
{
  return OBJ_ARRAY;
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

unsigned int Array::size() const
{
  return this->values.size();
}

void Array::clear()
{
  this->values.clear();
}
