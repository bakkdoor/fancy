#ifndef _CALLABLE_H_
#define _CALLABLE_H_

class Scope;
class FancyObject;
class Expression;

class Callable
{
public:
  virtual FancyObject* call(FancyObject *self, list<FancyObject*> args, Scope *scope) = 0;
};

typedef Callable* Callable_p;

#endif /* _CALLABLE_H_ */
