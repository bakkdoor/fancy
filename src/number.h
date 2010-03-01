#ifndef _NUMBER_H_
#define _NUMBER_H_

class Number;
typedef Number* Number_p;

class Number : public Object
{
 public:
  Number(double value);
  Number(int value);
  ~Number();
  
  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;

  bool is_double() const;
  double doubleval() const;
  int intval() const;
  
  static Number_p from_int(int value);
  static Number_p from_double(double value);

 private:
  int _intval;
  double _doubleval;
  bool _is_double;

  static map<int, Number_p> int_cache;
  static map<double, Number_p> double_cache;
};

#endif /* _NUMBER_H_ */
