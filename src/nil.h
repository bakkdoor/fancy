#ifndef _NIL_H_
#define _NIL_H_

namespace fancy {

  /**
   * Nil class representing nil value in Fancy.
   */
  class Nil : public FancyObject
  {
  public:
    /**
     * Nil constructor. Creates a new nil object.
     */
    Nil();
    ~Nil();

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual FancyObject_p eval(Scope *scope);
    virtual EXP_TYPE type() const;
    virtual string to_s() const;
  };

  typedef Nil* Nil_p;

}

#endif /* _NIL_H_ */
