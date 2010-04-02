#ifndef _NIL_H_
#define _NIL_H_

class Nil : public FancyObject
{
 public:
  Nil();
  ~Nil();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;
};

typedef Nil* Nil_p;

#endif /* _NIL_H_ */
