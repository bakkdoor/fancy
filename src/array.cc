#include "includes.h"

namespace fancy {

  Array::Array() : FancyObject(ArrayClass)
  {
  }

  Array::Array(int initial_size) : FancyObject(ArrayClass)
  {
    _values.resize(initial_size, nil);
  }

  Array::Array(int initial_size, FancyObject_p initial_value) : FancyObject(ArrayClass)
  {
    _values.resize(initial_size, initial_value);
  }

  Array::Array(array_node *val_list) : FancyObject(ArrayClass)
  {
    for(array_node *tmp = val_list; tmp; tmp = tmp->next) {
      if(tmp->value)
        _values.push_back(tmp->value);
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
    return at(index);
  }

  FancyObject_p Array::at(int index) const
  {
    // allow negative indexes
    if(index < 0) {
      int idx = _values.size() + index;
      if(idx >= 0) {
        return _values[idx];
      } else {
        return nil;
      }
    } else {
      if(index < (int)_values.size()) {
        return _values[index];
      } else {
        return nil;
      }
    }
  }

  FancyObject_p Array::set_value(unsigned int index, FancyObject_p value)
  {
    if(index < _values.size()) {
      _values[index] = value;
      return value;
    } else {
      return nil;
    }
  }

  FancyObject_p Array::insert(FancyObject_p value)
  {
    _values.push_back(value);
    return value;
  }

  FancyObject_p Array::insert_at(unsigned int index, FancyObject_p value)
  {
    set_value(index, value);
    return value;
  }

  FancyObject_p Array::remove_at(int index)
  {
    // ignore this case and simply return
    if(index > (int)size()) {
      return nil;
    }

    int idx = index;
    FancyObject_p value = at(index);
    // check for negative indexes
    if(index < 0) {
      idx = size() + index;
      if(idx < 0) {
        return nil; // somethings wrong here
      }
    }
    _values.erase(_values.begin() + idx);
    return value;
  }

  FancyObject_p Array::append(Array_p arr)
  {
    vector<FancyObject_p>::iterator it;
    for(it = arr->_values.begin(); it < arr->_values.end(); it++) {
      _values.push_back(*it);
    }
    return this;
  }

  FancyObject_p Array::first() const
  {
    if(_values.size() > 0) {
      return _values.front();
    } else {
      return nil;
    }
  }

  FancyObject_p Array::last() const
  {
    if(_values.size() > 0) {
      return _values.back();
    } else {
      return nil;
    }
  }

  EXP_TYPE Array::type() const
  {
    return EXP_ARRAY;
  }

  string Array::to_s() const
  {
    stringstream s;
    s << "[";
    for(unsigned int i = 0; i < _values.size(); i++) {
      s << _values[i]->to_s();
      if(i != (_values.size() - 1)) {
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
    for(unsigned int i = 0; i < _values.size(); i++) {
      s << _values[i]->inspect();
      if(i != (_values.size() - 1)) {
        s << ", ";
      }
    }
    s << "]";
    return s.str();
  }

  bool Array::operator==(const Array& other) const
  {
    if(_values.size() != other._values.size())
      return false;

    for(unsigned int i = 0; i < _values.size(); i++) {
      if(_values[i]->equal(other._values[i]) == nil) {
        return false;
      }
    }
    return true;
  }

  FancyObject_p Array::equal(const FancyObject_p other) const
  {
    if(other->type() != EXP_ARRAY)
      return nil;

    Array_p other_array = (Array_p)other;
    if((*this) == (*other_array))
      return t;
    return nil;
  }

  unsigned int Array::size() const
  {
    return _values.size();
  }

  void Array::clear()
  {
    _values.clear();
  }

  Array_p Array::clone() const
  {
    return new Array(_values);
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
