#ifndef _CLASS_DEFINITION_H_
#define _CLASS_DEFINITION_H_

class ClassDefExpr : public Expression
{
public:
  ClassDefExpr(Identifier_p class_name, ExpressionList_p class_body);
  ClassDefExpr(Identifier_p superclass_name, Identifier_p class_name, ExpressionList_p class_body);
  virtual ~ClassDefExpr();

  virtual FancyObject_p eval(Scope *scope);
  virtual OBJ_TYPE type() const;
  
private:
  Class_p _superclass;
  Identifier_p _superclass_name;
  Identifier_p _class_name;
  ExpressionList_p _class_body;
};

typedef ClassDefExpr* ClassDefExpr_p;

#endif /* _CLASS_DEFINITION_H_ */
