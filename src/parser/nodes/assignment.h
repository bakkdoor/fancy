#ifndef _ASSIGNMENT_H_
#define _ASSIGNMENT_H_

/**
 * Assignment expression class.
 * Used in the parser. 
 * When evaluated, sets the value of an identifier within the current
 * scope.
 */
class AssignmentExpr : public NativeObject
{
 public:
  AssignmentExpr(Identifier_p identifier, NativeObject_p value_expr);
  ~AssignmentExpr();
  
  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual string to_s() const;
  virtual FancyObject_p eval(Scope *scope);

 private:
  Identifier_p    identifier;
  NativeObject_p  value_expr;
};

typedef AssignmentExpr* AssignmentExpr_p;


#endif /* _ASSIGNMENT_H_ */
