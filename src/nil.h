#ifndef _NIL_H_
#define _NIL_H_

class Nil : public Object
{
 public:
  Nil();
  ~Nil();

  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;
};

typedef Nil* Nil_p;

#endif /* _NIL_H_ */
