#ifndef _ARRAY_LITERAL_H_
#define _ARRAY_LITERAL_H_

/**
 * ArrayLiteral class for Array literal values.
 * When evaluated, returns an instance of ArrayClass.
 * Only used within parser.
 */
class ArrayLiteral : public NativeObject
{
public:
  ArrayLiteral(expression_node *expr_list);
  ArrayLiteral(list<Expression_p> expressions);
  virtual ~ArrayLiteral();

  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual FancyObject_p eval(Scope *scope);
  virtual string to_s() const;

private:
  list<Expression_p> _expressions;
};

#endif /* _ARRAY_LITERAL_H_ */
