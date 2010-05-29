#ifndef _NIL_H_
#define _NIL_H_

#include "fancy_object.h"


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
    virtual FancyObject* equal(FancyObject* other) const;
    virtual FancyObject* eval(Scope *scope);
    virtual EXP_TYPE type() const;
    virtual string to_s() const;
  };

}

#endif /* _NIL_H_ */
