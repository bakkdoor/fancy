#include "includes.h"

MethodCall::MethodCall(Object_p receiver,
                       Identifier_p method_identifier,
                       Array_p arg_expressions) :
  Object(OBJ_METHODCALL),
  receiver(receiver),
  method_ident(method_identifier),
  method(0),
  arg_expressions(arg_expressions)
{
  cout << "new funcall: (" 
       << method_identifier->name() 
       << " " 
       << arg_expressions->to_s() 
       << ")" 
       << endl;
}

MethodCall::MethodCall(Object_p receiver,
                       Method_p method,
                       Array_p arg_expressions) :
  Object(OBJ_METHODCALL),
  receiver(receiver),
  method_ident(0),
  method(method),
  arg_expressions(arg_expressions)
{
}

MethodCall::~MethodCall()
{
}

Object_p MethodCall::equal(const Object_p other) const
{
  if(!IS_METHODCALL(other))
    return nil;

  MethodCall_p other_method_call = (MethodCall_p)other;

  // methodcalls are equal, if receiver, method & arguments are equal
  if(this->method) {
    if(other_method_call->method) {
      if((this->method->equal(other_method_call->method) != nil)
         && (this->arg_expressions->equal(other_method_call->arg_expressions) != nil)
         && (this->receiver->equal(other_method_call->receiver) != nil))
        return t;
      return nil;
    } else {
      return nil;
    }
  } else {
    if((this->method_ident->equal(other_method_call->method_ident) != nil)
       && (this->arg_expressions->equal(other_method_call->arg_expressions) != nil)
       && (this->receiver->equal(other_method_call->receiver) != nil))
      return t;
    return nil;
  }
}

Object_p MethodCall::eval(Scope *scope)
{
  if(this->method) {
    return eval_lambda_call(this->method, scope);
  }

  // cout << "eval funcall: " << this->func_ident->name() << " " << arg_expressions->to_s() << endl;
  Object_p func_obj = this->method_ident->eval(scope);
  if(func_obj == nil) {
    cerr << "ERROR: unkown method: " << this->method_ident->name() << endl;
    return nil;
  } else {
    if(IS_METHOD(func_obj)) {
      return eval_lambda_call(func_obj, scope);
    } else if(IS_BIF(func_obj)) {
      BuiltinMethod_p bif = (BuiltinMethod_p)func_obj;
      bif->arg_expressions = this->arg_expressions;
      return bif->eval(scope);
    } else {
      cerr << "ERROR: don't know how to call method: " << this->method_ident->name() << endl;
      return nil;
    }
  }
}

string MethodCall::to_s() const
{
  return "<methocall>";
}

Object_p MethodCall::eval_lambda_call(Object_p func_obj, Scope *scope)
{
  // Scope *call_scope = new Scope(scope);
  // vector<Object_p> arg_expr_v;
  
  // Object_p cons = this->arg_expressions;
  
  // while(functions::car(cons, scope) != nil) {
  //   arg_expr_v.push_back(functions::car(cons, scope));
  //   cons = functions::cdr(cons, scope);
  // }
  
  // Method_p func = (Method_p)func_obj;
  
  // if(func->argcount() > arg_expr_v.size()) {
  //   cerr << "ERROR: given amount of arguments (" 
  //        << arg_expr_v.size()
  //        << ") is smaller than expected ("
  //        << func->argcount()
  //        << ") for method: " 
  //        << this->func_ident->name()
  //        << endl;
  // }
  // for(unsigned int i = 0; i < arg_expr_v.size(); i++) {
  //   call_scope->define(func->argnames()[i], arg_expr_v[i]->eval(call_scope));
  // }
  // return func->eval(call_scope);
  return nil;
}
