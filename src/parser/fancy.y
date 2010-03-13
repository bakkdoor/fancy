%{
#include "includes.h"


  int yyerror(char *s);
  int yylex(void);
  key_val_node* key_val_obj(NativeObject_p key, NativeObject_p val, key_val_node *next);
  array_node* val_list_obj(NativeObject_p val, array_node *next);

  list< pair<Identifier_p, Identifier_p> > method_args;
  list< pair<Identifier_p, Expression_p> > methodcall_args;
  list<Expression_p> expression_list;
%}

%union{
  key_val_node      *key_val_list;
  array_node        *value_list;
  /* method_arg_node   *method_args; */

  NativeObject  *object;
  Identifier    *identifier;
  Number        *number;
  Regex         *regex;
  String        *string;
  Array         *array;
  Expression    *expression;
}

%start	programm

%token                  LPAREN
%token                  RPAREN
%token                  LCURLY
%token                  RCURLY
%token                  LBRACKET
%token                  RBRACKET
%token                  ARROW
%token                  COMMA
%token                  SEMI
%token                  COLON
%token                  CLASS
%token                  DEF
%token                  INHERIT
%token                  DOT
%token                  DOLLAR
%token                  EQUALS

%token <number>             INTEGER_LITERAL
%token <number>             DOUBLE_LITERAL
%token <string>             STRING_LITERAL
%token <identifier>         SYMBOL_LITERAL
%token <regex>              REGEX_LITERAL
%token <identifier>         IDENTIFIER
%token <identifier>         OPERATOR
%type  <object>             literal_value
%type  <object>             hash_literal
%type  <object>             array_literal
%type  <key_val_list>       key_value_list


%type  <object>             empty_array
%type  <object>             exp
%type  <object>             assignment

%type  <expression>         class_def
%type  <expression>         class_no_super
%type  <expression>         class_super
%type  <expression>         class_method_w_args
%type  <expression>         class_method_no_args

%type  <expression>         method_def
%type  <expression>         method_w_args
%type  <expression>         method_no_args

%type  <expression>         method_call
%type  <expression>         operator_call
%type  <expression>         receiver
%type  <expression>         arg_exp


%%

programm:       /* empty */
                | exp  { Expression_p expr = $1; expr->eval(global_scope); }
                | programm SEMI exp { Expression_p expr = $3; expr->eval(global_scope); }
                ;

exp:            assignment
                | method_def
                | class_def
                | method_call
                | operator_call
                | literal_value
                | IDENTIFIER
                | LPAREN exp RPAREN { $$ = $2; }
                ;

assignment:     IDENTIFIER EQUALS exp {
                  $$ = new AssignmentExpr($1, $3);
                }
                ;

class_def:      class_no_super
                | class_super
                ;

class_no_super: DEF CLASS IDENTIFIER LCURLY exp_list RCURLY {
                  $$ = nil;
                  /* $$ = new ClassDefExpr */
                }
                ;

class_super:    DEF CLASS IDENTIFIER INHERIT IDENTIFIER LCURLY exp_list RCURLY {
                  $$ = nil;
                  /* $$ = new ClassDefExpr */
                }
                ;

method_def:     method_w_args
                | method_no_args
                | class_method_w_args
                | class_method_no_args
                ;

method_args:    IDENTIFIER COLON IDENTIFIER { 
                  method_args.push_back(pair<Identifier_p, Identifier_p>($1, $3));
                }
                | method_args IDENTIFIER COLON IDENTIFIER {
                  method_args.push_back(pair<Identifier_p, Identifier_p>($2, $4));
                }
                ;

method_w_args:  DEF method_args LCURLY exp_list RCURLY {
                  ExpressionList_p body = new ExpressionList(expression_list);
                  expression_list.clear();
                  Method_p method = new Method(method_args, body);
                  // TODO: set method_args correctly
                  $$ = new MethodDefExpr(method_args, method);
                  method_args.clear();
                }
                ;


method_no_args: DEF IDENTIFIER LCURLY exp_list RCURLY {
                  ExpressionList_p body = new ExpressionList(expression_list);
                  expression_list.clear();
                  list< pair<Identifier_p, Identifier_p> > empty_args;
                  Method_p method = new Method(empty_args, body);
                  $$ = new MethodDefExpr(empty_args, method);
                }
                ;

class_method_w_args: DEF IDENTIFIER method_args LCURLY exp_list RCURLY {
                  // TODO: change for class method specific stuff
                  ExpressionList_p body = new ExpressionList(expression_list);
                  expression_list.clear();
                  Method_p method = new Method(method_args, body);
                  // TODO: set method_args correctly
                  $$ = new MethodDefExpr(method_args, method);
                  method_args.clear();
                }
                ;

class_method_no_args: DEF IDENTIFIER IDENTIFIER LCURLY exp_list RCURLY {
                  // TODO: change for class method specific stuff
                  ExpressionList_p body = new ExpressionList(expression_list);
                  expression_list.clear();
                  list< pair<Identifier_p, Identifier_p> > empty_args;
                  Method_p method = new Method(empty_args, body);
                  $$ = new MethodDefExpr(empty_args, method);
                }
                ;


method_call:    receiver IDENTIFIER { $$ = new MethodCall($1, $2);  }
                /* | IDENTIFIER call_args {  */
                /*   $$ = new MethodCall($1, methodcall_args); */
                /*   methodcall_args.clear(); */
                /* }  */
                | receiver call_args {
                   $$ = new MethodCall($1, methodcall_args);
                   methodcall_args.clear();
                }
                ;


operator_call:  receiver OPERATOR exp {
                  $$ = new OperatorCall($1, $2, $3);
                }
                ;

receiver:       | /* empty */ { $$ = Identifier::from_string("self"); }
                | LPAREN exp RPAREN { $$ = $2; }
                | exp { $$ = $1; }
                | IDENTIFIER { $$ = $1; }
                | exp DOT { $$ = $1; }
                ;

call_args:      IDENTIFIER COLON arg_exp { methodcall_args.push_back(pair<Identifier_p, Expression_p>($1, $3)); }
                | call_args call_args
                ;

arg_exp:        IDENTIFIER { $$ = $1; }
                | LPAREN exp RPAREN { $$ = $2; }
                | literal_value { $$ = $1; }
                | DOLLAR exp { $$ = $2; }
                ;

literal_value:  INTEGER_LITERAL	{ $$ = $1; }
                | DOUBLE_LITERAL { $$ = $1; }
                | STRING_LITERAL { $$ = $1; }
                | SYMBOL_LITERAL { $$ = $1; }
                | hash_literal { $$ = $1; }
                | array_literal { $$ = $1; }
                | REGEX_LITERAL { $$ = $1; }
                ;


array_literal:  empty_array
                | LBRACKET exp_list RBRACKET { $$ = ArrayClass->create_instance(new Array(expression_list)); }
                ;

empty_array:    LBRACKET RBRACKET { $$ = ArrayClass->create_instance(new Array(0)); }
                ;

exp_list:       exp { expression_list.push_back($1); }
                | exp_list COMMA exp { expression_list.push_back($3); }
                ;


hash_literal:   LCURLY key_value_list RCURLY { $$ = HashClass->create_instance(new Hash($2)); }
                ;

key_value_list: SYMBOL_LITERAL ARROW exp { $$ = key_val_obj($1, $3, NULL); }
                | SYMBOL_LITERAL ARROW literal_value { $$ = key_val_obj($1, $3, NULL); }
                | SYMBOL_LITERAL ARROW exp key_value_list { 
                  $$ = key_val_obj($1, $3, $4); 
                }
                | SYMBOL_LITERAL ARROW literal_value key_value_list { 
                  $$ = key_val_obj($1, $3, $4);
                }
                ;

%%

int yyerror(char *s)
{
  extern int yylineno;
  extern char *yytext;
  
  fprintf(stderr, "ERROR: %s at symbol %s on line %d\n", s, yytext, yylineno);
  exit(1);
}

key_val_node* key_val_obj(NativeObject_p key, NativeObject_p val, key_val_node *next)
{
  key_val_node *node = new key_val_node;
  node->key = key;
  node->val = val;
  node->next = next;
  return node;
}

array_node* val_list_obj(NativeObject_p val, array_node *next)
{
  array_node *node = new array_node;
  node->value = val;
  node->next = next;
  return node;
}
