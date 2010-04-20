#ifndef _NUMBER_H_
#define _NUMBER_H_

namespace fancy {

  class Number;
  typedef Number* Number_p;

  #define INT_CACHE_SIZE 1000

  class Number : public FancyObject
  {
  public:
    Number(double value);
    Number(int value);
    ~Number();
  
    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual OBJ_TYPE type() const;
    virtual string to_s() const;

    bool is_double() const;
    double doubleval() const;
    int intval() const;
  
    static Number_p from_int(int value);
    static Number_p from_double(double value);

    static void init_cache();

  private:
    int _intval;
    double _doubleval;
    bool _is_double;

    static Number_p* int_cache;
  };

}

#endif /* _NUMBER_H_ */
