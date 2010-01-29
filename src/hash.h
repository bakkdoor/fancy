#ifndef _HASH_H_
#define _HASH_H_

struct key_val_node {
public:
  Object_p key;
  Object_p val;
  key_val_node *next;
};

class Hash : public Object
{
 public:
  Hash(key_val_node *key_val_list);
  Hash(map<Object_p, Object_p> map);
  ~Hash();

  Object_p operator[](Object_p key) const;
  Object_p set_value(Object_p key, Object_p value);

  virtual Object_p equal(const Object_p other) const;
  virtual Object_p eval(Scope *scope);
  virtual string to_s() const;

  bool operator==(const Hash& other) const;
  
  int size() const;

 private:
  map<Object_p, Object_p> mappings;
};

typedef Hash* Hash_p;

#endif /* _HASH_H_ */
