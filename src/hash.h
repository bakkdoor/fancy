#ifndef _HASH_H_
#define _HASH_H_

struct key_val_node {
public:
  NativeObject_p key;
  NativeObject_p val;
  key_val_node *next;
};

class Hash : public NativeObject
{
 public:
  Hash(key_val_node *key_val_list);
  Hash(map<NativeObject_p, NativeObject_p> map);
  ~Hash();

  NativeObject_p operator[](NativeObject_p key) const;
  NativeObject_p set_value(NativeObject_p key, NativeObject_p value);

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual NativeObject_p eval(Scope *scope);
  virtual string to_s() const;

  bool operator==(const Hash& other) const;
  
  int size() const;

 private:
  map<NativeObject_p, NativeObject_p> mappings;
};

typedef Hash* Hash_p;

#endif /* _HASH_H_ */
