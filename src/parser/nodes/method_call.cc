#include "includes.h"

MethodCall::MethodCall(Expression_p receiver,
                       list< pair<Identifier_p, Expression_p> > method_arg_expr) :
  NativeObject(),
  receiver(receiver),
  arg_expressions(method_arg_expr)
{
  init_method_ident();
}

MethodCall::MethodCall(Expression_p receiver, Identifier_p method_ident) :
  NativeObject(),
  receiver(receiver),
  method_ident(method_ident)
{
}

MethodCall::~MethodCall()
{
}

NativeObject_p MethodCall::equal(const NativeObject_p other) const
{
  if(!IS_METHODCALL(other))
    return nil;

  // MethodCall_p other_method_call = (MethodCall_p)other;

  // methodcalls are equal, if receiver, method & arguments are equal
  // if(this->method) {
  //   if(other_method_call->method) {
  //     if((this->method->equal(other_method_call->method) != nil)
  //        && (this->arg_expressions->equal(other_method_call->arg_expressions) != nil)
  //        && (this->receiver->equal(other_method_call->receiver) != nil))
  //       return t;
  //     return nil;
  //   } else {
  //     return nil;
  //   }
  // } else {
  //   if((this->method_ident->equal(other_method_call->method_ident) != nil)
  //      && (this->arg_expressions->equal(other_method_call->arg_expressions) != nil)
  //      && (this->receiver->equal(other_method_call->receiver) != nil))
  //     return t;
  //   return nil;
  // }
  return nil;
}

FancyObject_p MethodCall::eval(Scope *scope)
{
  list< pair<Identifier_p, Expression_p> >::iterator it;
  list<FancyObject_p> args;
  for(it = arg_expressions.begin(); it != arg_expressions.end(); it++) {
    Expression_p exp = (*it).second;
    args.push_back(exp->eval(scope));
  }  
  
  FancyObject_p receiver_obj = receiver->eval(scope);
  return receiver_obj->call_method(this->method_ident->to_s(), args, scope);
}

OBJ_TYPE MethodCall::type() const
{
  return OBJ_METHODCALL;
}

string MethodCall::to_s() const
{  
  return "<methocall>";
}

void MethodCall::init_method_ident()
{
  stringstream str;
  list< pair<Identifier_p, Expression_p> >::iterator it;
  for(it = this->arg_expressions.begin(); it != this->arg_expressions.end(); it++) {
    str << it->first->to_s();
    str << ":";
  }

  this->method_ident = Identifier::from_string(str.str());
}
