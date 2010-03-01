#ifndef _EXPRESSION_LIST_H_
#define _EXPRESSION_LIST_H_

class ExpressionList : public Expression
{
 public:
  ExpressionList(list<Expression_p> expressions);
  ~ExpressionList();
  
  virtual Object_p eval(Scope *scope);
  virtual Object_p equal(const Object_p other) const;

 private:
  list<Expression_p> expressions;
};

typedef ExpressionList* ExpressionList_p;

#endif /* _EXPRESSION_LIST_H_ */
