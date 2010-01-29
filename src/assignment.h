#ifndef _ASSIGNMENT_H_
#define _ASSIGNMENT_H_

class AssignmentExpr : public Object
{
 public:
  AssignmentExpr(Identifier *identifier, Object_p value_expr);
  ~AssignmentExpr();
  
  virtual Object_p equal(const Object_p other) const;
  virtual string to_s() const;
  virtual Object_p eval(Scope *scope);

 private:
  Identifier  *identifier;
  Object_p value_expr;
};

typedef AssignmentExpr* AssignmentExpr_p;


#endif /* _ASSIGNMENT_H_ */
