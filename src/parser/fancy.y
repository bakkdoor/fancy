%{
#include "includes.h"


  int yyerror(char *s);
  int yylex(void);
  key_val_node* key_val_obj(Object_p key, Object_p val, key_val_node *next);
  array_node* val_list_obj(Object_p val, array_node *next);
  list< pair<Identifier_p, Identifier_p> > method_args;
%}

%union{
  key_val_node      *key_val_list;
  array_node        *value_list;
  /* method_arg_node   *method_args; */

  Object        *object;
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
%type  <object>             literal_value
%type  <object>             hash_literal
%type  <object>             array_literal
%type  <key_val_list>       key_value_list
%type  <value_list>         exp_list

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

/* %type  <expression>         method_call */
%type  <expression>         receiver
/* %type  <expression>         argument_list */

%%

programm:       /* empty */
                | programm exp { Expression_p expr = $2; expr->eval(global_scope); }
                ;

exp:            assignment
                | method_def
                | class_def
                /* | method_call */
                | literal_value
                | exp_list
                ;

assignment:     IDENTIFIER EQUALS exp {
                  $$ = new AssignmentExpr($1, $3);
                }
                ;

class_def:      class_no_super
                | class_super
                ;

class_no_super: CLASS IDENTIFIER LCURLY exp_list RCURLY {
                  $$ = nil;
                  /* $$ = new ClassDefExpr */
                }
                ;

class_super:    CLASS IDENTIFIER INHERIT IDENTIFIER LCURLY exp_list RCURLY {
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
                  ExpressionList_p body = new ExpressionList(new Array($4));
                  Method_p method = new Method(new Array(0), body);
                  // TODO: set method_args correctly
                  $$ = new MethodDefExpr(method_args, method);
                  method_args.clear();
                }
                ;


method_no_args: DEF IDENTIFIER LCURLY exp_list RCURLY {
                  ExpressionList_p body = new ExpressionList(new Array($4));
                  Method_p method = new Method(new Array(0), body);
                  list< pair<Identifier_p, Identifier_p> > m_args;
                  $$ = new MethodDefExpr(m_args, method);
                }
                ;

class_method_w_args: DEF IDENTIFIER method_args LCURLY exp_list RCURLY {
                  // TODO: change for class method specific stuff
                  ExpressionList_p body = new ExpressionList(new Array($5));
                  Method_p method = new Method(new Array(0), body);
                  // TODO: set method_args correctly
                  $$ = new MethodDefExpr(method_args, method);
                  method_args.clear();
                }
                ;

class_method_no_args: DEF IDENTIFIER IDENTIFIER LCURLY exp_list RCURLY {
                  // TODO: change for class method specific stuff
                  ExpressionList_p body = new ExpressionList(new Array($5));
                  Method_p method = new Method(new Array(0), body);
                  list< pair<Identifier_p, Identifier_p> > m_args;
                  $$ = new MethodDefExpr(m_args, method);
                }
                ;


/* method_call:    receiver IDENTIFIER LPAREN argument_list RPAREN { */
/*                   $$ = new MethodCall($1, $2, $4); */
/*                 } */
/*                 ; */

receiver:       LPAREN exp RPAREN { $$ = $2; }
                | exp { $$ = $1; }
                | { $$ = new Identifier("self"); }
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
                | LBRACKET exp_list RBRACKET { $$ = new Array($2); }
                ;

empty_array:    LBRACKET RBRACKET { $$ = new Array(0); }
                ;

exp_list:       exp { $$ = val_list_obj($1, NULL); }
                | exp COMMA exp_list { $$ = val_list_obj($1, $3); }
                ;


hash_literal:   LCURLY key_value_list RCURLY { $$ = new Hash($2); }
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

key_val_node* key_val_obj(Object_p key, Object_p val, key_val_node *next)
{
  key_val_node *node = new key_val_node;
  node->key = key;
  node->val = val;
  node->next = next;
  return node;
}

array_node* val_list_obj(Object_p val, array_node *next)
{
  array_node *node = new array_node;
  node->value = val;
  node->next = next;
  return node;
}
