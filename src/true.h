#ifndef _TRUE_H_
#define _TRUE_H_

namespace fancy {

  class True : public FancyObject
  {
  public:
    True();
    ~True();

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual FancyObject_p eval(Scope *scope);
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;
  };

  typedef True* True_p;

}

#endif /* _TRUE_H_ */
