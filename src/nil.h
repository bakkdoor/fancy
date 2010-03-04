#ifndef _NIL_H_
#define _NIL_H_

class Nil : public NativeObject
{
 public:
  Nil();
  ~Nil();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual string to_s() const;
};

typedef Nil* Nil_p;

#endif /* _NIL_H_ */
