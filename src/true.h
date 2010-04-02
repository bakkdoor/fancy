#ifndef _TRUE_H_
#define _TRUE_H_

class True : public FancyObject
{
 public:
  True();
  ~True();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;
};

typedef True* True_p;

#endif /* _TRUE_H_ */
