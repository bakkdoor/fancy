#include <sstream>
#include "array.h"
#include "bootstrap/core_classes.h"

namespace fancy {

  Array::Array() : FancyObject(ArrayClass)
  {
  }

  Array::Array(int initial_size) : FancyObject(ArrayClass)
  {
    _values.resize(initial_size, nil);
  }

  Array::Array(int initial_size, FancyObject* initial_value) : FancyObject(ArrayClass)
  {
    _values.resize(initial_size, initial_value);
  }

  Array::Array(array_node* val_list) : FancyObject(ArrayClass)
  {
    for(array_node* tmp = val_list; tmp; tmp = tmp->next) {
      if(tmp->value)
        _values.push_back(tmp->value);
    }
  }

  Array::Array(vector<FancyObject*> list) :
    FancyObject(ArrayClass), _values(list)
  {
  }

  Array::~Array()
  {
  }

  FancyObject* Array::operator[](int index) const
  {
    return at(index);
  }

  FancyObject* Array::at(int index) const
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

  FancyObject* Array::set_value(unsigned int index, FancyObject* value)
  {
    if(index < _values.size()) {
      _values[index] = value;
      return value;
    } else {
      return nil;
    }
  }

  FancyObject* Array::insert(FancyObject* value)
  {
    _values.push_back(value);
    return value;
  }

  FancyObject* Array::insert_at(unsigned int index, FancyObject* value)
  {
    set_value(index, value);
    return value;
  }

  FancyObject* Array::remove_at(int index)
  {
    // ignore this case and simply return
    if(index > (int)size()) {
      return nil;
    }

    int idx = index;
    FancyObject* value = at(index);
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

  FancyObject* Array::append(Array* arr)
  {
    vector<FancyObject*>::iterator it;
    for(it = arr->_values.begin(); it < arr->_values.end(); it++) {
      _values.push_back(*it);
    }
    return this;
  }

  FancyObject* Array::first() const
  {
    if(_values.size() > 0) {
      return _values.front();
    } else {
      return nil;
    }
  }

  FancyObject* Array::last() const
  {
    if(_values.size() > 0) {
      return _values.back();
    } else {
      return nil;
    }
  }

  Array* Array::last(int n) const
  {
    if((n > 0) && ((unsigned int)n <= _values.size())) {
      vector<FancyObject*> subarr(n, nil);
      int count = 0;
      for(unsigned int i = _values.size() - n; i < _values.size(); i++) {
        subarr[count++] = _values[i];
      }
      return new Array(subarr);
    }
    return new Array();
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

  unsigned int Array::size() const
  {
    return _values.size();
  }

  void Array::clear()
  {
    _values.clear();
  }

  Array* Array::clone() const
  {
    return new Array(_values);
  }

  list<FancyObject*> Array::to_list() const
  {
    return list<FancyObject*>(_values.begin(), _values.end());
  }

}
