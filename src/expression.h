#ifndef _EXPRESSION_H_
#define _EXPRESSION_H_

class Scope;
class NativeObject;
typedef NativeObject* NativeObject_p;

class Expression : public gc_cleanup
{
 public:
  virtual NativeObject_p eval(Scope *scope) = 0;
  virtual NativeObject_p equal(const NativeObject_p other) const = 0;
};

typedef Expression* Expression_p;

#endif /* _EXPRESSION_H_ */
