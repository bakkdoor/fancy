#ifndef _NUMBER_H_
#define _NUMBER_H_

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

 private:
  int _intval;
  double _doubleval;
  bool _is_double;
};

typedef Number* Number_p;

#endif /* _NUMBER_H_ */
