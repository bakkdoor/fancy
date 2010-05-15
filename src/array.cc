#include "includes.h"

namespace fancy {

  Array::Array() : FancyObject(ArrayClass)
  {
  }

  Array::Array(int initial_size) : FancyObject(ArrayClass)
  {
    this->_values.resize(initial_size, nil);
  }

  Array::Array(int initial_size, FancyObject_p initial_value) : FancyObject(ArrayClass)
  {
    this->_values.resize(initial_size, initial_value);
  }

  Array::Array(array_node *val_list) : FancyObject(ArrayClass)
  {
    for(array_node *tmp = val_list; tmp; tmp = tmp->next) {
      if(tmp->value)
        this->_values.push_back(tmp->value);
    }
  }

  Array::Array(vector<FancyObject_p> list) :
    FancyObject(ArrayClass), _values(list)
  {
  }

  Array::~Array() 
  {
  }

  FancyObject_p Array::operator[](int index) const
  {
    return this->at(index);
  }

  FancyObject_p Array::at(int index) const
  {
    // allow negative indexes
    if(index < 0) {
      int idx = this->_values.size() + index;
      if(idx >= 0) {
        return this->_values[idx];
      } else {
        return nil;
      }
    } else {
      if(index < this->_values.size()) {
        return this->_values[index];
      } else {
        return nil;
      }
    }
  }

  FancyObject_p Array::set_value(unsigned int index, FancyObject_p value)
  {
    if(index < this->_values.size()) {
      this->_values[index] = value;
      return value;
    } else {
      return nil;
    }
  }

  FancyObject_p Array::insert(FancyObject_p value)
  {
    this->_values.push_back(value);
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
    for(it = arr->_values.begin(); it < arr->_values.end(); it++) {
      this->_values.push_back(*it);
    }
    return this;
  }

  FancyObject_p Array::first() const
  {
    if(this->_values.size() > 0) {
      return this->_values.front();
    } else {
      return nil;
    }
  }

  FancyObject_p Array::last() const
  {
    if(this->_values.size() > 0) {
      return this->_values.back();
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
    for(unsigned int i = 0; i < this->_values.size(); i++) {
      s << this->_values[i]->to_s();
      if(i != (this->_values.size() - 1)) {
        s << ", ";
      }
    }
    s << "]";
    return s.str();
  }

  string Array::inspect() const
  {
    stringstream s;
    s << "[";
    for(unsigned int i = 0; i < this->_values.size(); i++) {
      s << this->_values[i]->inspect();
      if(i != (this->_values.size() - 1)) {
        s << ", ";
      }
    }
    s << "]";
    return s.str();
  }

  bool Array::operator==(const Array& other) const
  {
    if(this->_values.size() != other._values.size())
      return false;

    for(unsigned int i = 0; i < this->_values.size(); i++) {
      if(this->_values[i]->equal(other._values[i]) == nil) {
        return false;
      }
    }
    return true;
  }

  FancyObject_p Array::equal(const FancyObject_p other) const
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
    return this->_values.size();
  }

  void Array::clear()
  {
    this->_values.clear();
  }

  Array_p Array::clone() const
  {
    return new Array(this->_values);
  }

  list<FancyObject_p> Array::to_list() const
  {
    return list<FancyObject_p>(_values.begin(), _values.end());
  }

  vector<FancyObject_p> Array::values() const
  {
    return _values;
  }

}
