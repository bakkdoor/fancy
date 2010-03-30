#ifndef _BLOCK_H_
#define _BLOCK_H_

/**
 * Block class.
 * A block is (as in Ruby or Smalltalk) an object (instance of
 * BlockClass) that represents an anonymous method / a closure.
 */
class Block : public NativeObject, public Callable
{
public:
  Block(ExpressionList_p body, Scope *creation_scope);
  Block(list<Identifier_p> argnames, ExpressionList_p body, Scope *creation_scope);
  virtual ~Block();

  virtual FancyObject_p eval(Scope *scope);
  virtual NativeObject_p equal(const NativeObject_p other) const;
  virtual string to_s() const;

  FancyObject_p call(FancyObject_p self, list<FancyObject_p> args, Scope *scope);

  void set_creation_scope(Scope *creation_scope);
  Scope* creation_scope() const;

private:
  void init_fancy_obj_cache();
  
  list<Identifier_p> _argnames;
  ExpressionList_p _body;
  FancyObject_p _block_fancy_obj;
  Scope *_creation_scope;
};

typedef Block* Block_p;

#endif /* _BLOCK_H_ */
