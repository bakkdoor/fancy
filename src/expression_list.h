#ifndef _EXPRESSION_LIST_H_
#define _EXPRESSION_LIST_H_

struct expression_node {
  Expression_p     expression;
  expression_node *next;
};

class ExpressionList : public Expression
{
 public:
  ExpressionList(list<Expression_p> expressions);
  ExpressionList(expression_node *list);
  ~ExpressionList();
  
  virtual FancyObject_p eval(Scope *scope);
  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual OBJ_TYPE type() const;

  unsigned int size() const;

 private:
  list<Expression_p> expressions;
};

typedef ExpressionList* ExpressionList_p;

#endif /* _EXPRESSION_LIST_H_ */
