#ifndef _T_H_
#define _T_H_

class T : public NativeObject
{
 public:
  T();
  ~T();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual string to_s() const;
};

typedef T* T_p;

#endif /* _T_H_ */
