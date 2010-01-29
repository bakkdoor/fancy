#ifndef _T_H_
#define _T_H_

class T : public Object
{
 public:
  T();
  ~T();

  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;
};

typedef T* T_p;

#endif /* _T_H_ */
