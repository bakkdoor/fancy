#ifndef _TRUE_H_
#define _TRUE_H_

#include "fancy_object.h"

namespace fancy {

  /**
   * True class representing true value in Fancy.
   */
  class True : public FancyObject
  {
  public:
    /**
     * True constructor. Creates a new true value.
     */
    True();
    ~True() {}

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject* equal(FancyObject* other) const;
    virtual FancyObject* eval(Scope *scope);
    virtual EXP_TYPE type() const { return EXP_TRUE; }
    virtual string to_s() const { return "true"; }
    virtual string inspect() const { return "true"; }
  };

}

#endif /* _TRUE_H_ */
