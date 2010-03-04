#ifndef _EXPRESSION_LIST_H_
#define _EXPRESSION_LIST_H_

class ExpressionList : public Expression
{
 public:
  ExpressionList(list<Expression_p> expressions);
  ~ExpressionList();
  
  virtual FancyObject_p eval(Scope *scope);
  virtual NativeObject_p equal(const NativeObject_p other) const;

 private:
  list<Expression_p> expressions;
};

typedef ExpressionList* ExpressionList_p;

#endif /* _EXPRESSION_LIST_H_ */
