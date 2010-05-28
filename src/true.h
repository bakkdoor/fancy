#ifndef _TRUE_H_
#define _TRUE_H_

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
    ~True();

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual FancyObject_p eval(Scope *scope);
    virtual EXP_TYPE type() const;
    virtual string to_s() const;
  };

  typedef True* True_p;

}

#endif /* _TRUE_H_ */
