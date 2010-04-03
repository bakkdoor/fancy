#ifndef _HASH_H_
#define _HASH_H_

class Hash : public FancyObject
{
 public:
  Hash();
  Hash(map<FancyObject_p, FancyObject_p> mappings);
  ~Hash();

  FancyObject_p operator[](FancyObject_p key) const;
  FancyObject_p set_value(FancyObject_p key, FancyObject_p value);

  virtual FancyObject_p equal(const FancyObject_p other) const;
  virtual OBJ_TYPE type() const;
  virtual string to_s() const;

  bool operator==(const Hash& other) const;
  
  int size() const;

 private:
  map<FancyObject_p, FancyObject_p> mappings;
};

typedef Hash* Hash_p;

#endif /* _HASH_H_ */
