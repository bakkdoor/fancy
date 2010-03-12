#ifndef _BLOCK_H_
#define _BLOCK_H_

class Block : public NativeObject
{
public:
  Block(ExpressionList_p body);
  Block(list<Identifier_p> argnames, ExpressionList_p body);
  virtual ~Block();

  virtual FancyObject_p eval(Scope *scope);
  FancyObject_p call(list<Expression_p> args, Scope *scope);

private:
  void init_fancy_obj_cache();
  
  list<Identifier_p> _argnames;
  ExpressionList_p _body;
  FancyObject_p _block_fancy_obj;
};

#endif /* _BLOCK_H_ */
