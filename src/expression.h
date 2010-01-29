#ifndef _EXPRESSION_H_
#define _EXPRESSION_H_

class Scope;
class Object;
typedef Object* Object_p;

class Expression : public gc_cleanup
{
 public:
  virtual Object_p eval(Scope *scope) = 0;
  virtual Object_p equal(const Object_p other) const = 0;
};

typedef Expression* Expression_p;

#endif /* _EXPRESSION_H_ */
