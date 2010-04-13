#ifndef _EXPRESSION_H_
#define _EXPRESSION_H_

namespace fancy {

  class Scope;
  class FancyObject;

  enum OBJ_TYPE {
    OBJ_NIL = 0,
    OBJ_TRUE,
    OBJ_INTEGER,
    OBJ_DOUBLE,
    OBJ_IDENTIFIER,
    OBJ_SYMBOL,
    OBJ_STRING,
    OBJ_HASH,
    OBJ_HASHLITERAL,
    OBJ_REGEX,
    OBJ_ARRAY,
    OBJ_ARRAYLITERAL,
    OBJ_METHOD,
    OBJ_NATIVEMETHOD,
    OBJ_METHODCALL,
    OBJ_OPCALL,
    OBJ_ASSIGNEXPR,
    OBJ_RETURNSTATEMENT,
    OBJ_EXPRLIST,
    OBJ_METHODDEFEXPR,
    OBJ_OPERATORDEFEXPR,
    OBJ_MODULE,
    OBJ_CLASS,
    OBJ_CLASSINSTANCE,
    OBJ_CLASSDEFEXPR,
    OBJ_BLOCK,
    OBJ_BLOCKLITERAL,
    OBJ_FILE,
    OBJ_SCOPE
  };

  class Expression : public gc_cleanup
  {
  public:
    virtual FancyObject* eval(Scope *scope) = 0;
    virtual OBJ_TYPE type() const = 0;
  };

  typedef Expression* Expression_p;

}

#endif /* _EXPRESSION_H_ */
