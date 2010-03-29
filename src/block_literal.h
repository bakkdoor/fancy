#ifndef _BLOCK_LITERAL_H_
#define _BLOCK_LITERAL_H_

class BlockLiteral : public NativeObject
{
public:
  BlockLiteral(ExpressionList_p body);
  BlockLiteral(list<Identifier_p> argnames, ExpressionList_p body);
  virtual ~BlockLiteral();

  virtual FancyObject_p eval(Scope *scope);
  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual string to_s() const;

private:
  list<Identifier_p> _argnames;
  ExpressionList_p _body;
};

#endif /* _BLOCK_LITERAL_H_ */
