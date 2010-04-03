#ifndef _HASH_LITERAL_H_
#define _HASH_LITERAL_H_

struct key_val_node {
public:
  Expression_p key;
  Expression_p val;
  key_val_node *next;
};

class HashLiteral : public Expression
{
public:
  HashLiteral(key_val_node *key_val_list);
  HashLiteral(list< pair<Expression_p, Expression_p> > key_val_list);
  virtual ~HashLiteral();

  virtual FancyObject_p eval(Scope *scope);
  virtual OBJ_TYPE type() const;

private:
  list< pair<Expression_p, Expression_p> > _key_val_list;
};

#endif /* _HASH_LITERAL_H_ */
