%{
  #include "includes.h"
  
  string current_file;

  int yyerror(char *s);
  int yylex(void);
  key_val_node* key_val_obj(NativeObject_p key, NativeObject_p val, key_val_node *next);
  expression_node* expr_node(Expression_p expr, expression_node *next);

  list< pair<Identifier_p, Identifier_p> > method_args;
  list< pair<Identifier_p, Expression_p> > methodcall_args;
  list<Identifier_p> block_args;
  list<Expression_p> expression_list;
%}

%union{
  key_val_node      *key_val_list;
  array_node        *value_list;
  expression_node   *expr_list;
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
%token                  STAB
%token                  ARROW
%token                  COMMA
%token                  SEMI
%token                  COLON
%token                  CLASS
%token                  DEF
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
%type  <expr_list>          exp_list
%type  <expr_list>          exp_comma_list
%type  <expr_list>          method_body


%type  <object>             empty_array
%type  <object>             code
%type  <object>             exp
%type  <object>             assignment
%type  <object>             block_literal

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
                | code { Expression_p expr = $1; expr->eval(global_scope); }
                | programm SEMI code { Expression_p expr = $3; expr->eval(global_scope); }
                ;

code:           statement
                | exp
                ;

statement:      assignment
                ;

exp:            method_def
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
                  $$ = new ClassDefExpr($3, new ExpressionList($5));
                }
                ;

class_super:    DEF CLASS IDENTIFIER COLON IDENTIFIER LCURLY exp_list RCURLY {
                  $$ = new ClassDefExpr($5, $3, new ExpressionList($7));
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

method_body:    code { $$ = expr_node($1, 0); }
                | method_body SEMI code { $$ = expr_node($3, $1); }
                ;

method_w_args:  DEF method_args LCURLY method_body RCURLY {
                  ExpressionList_p body = new ExpressionList($4);
                  Method_p method = new Method(method_args, body);
                  // TODO: set method_args correctly
                  $$ = new MethodDefExpr(method_args, method);
                  method_args.clear();
                }
                ;


method_no_args: DEF IDENTIFIER LCURLY method_body RCURLY {
                  ExpressionList_p body = new ExpressionList($4);
                  list< pair<Identifier_p, Identifier_p> > empty_args;
                  Method_p method = new Method(empty_args, body);
                  $$ = new MethodDefExpr($2, method);
                }
                ;

class_method_w_args: DEF IDENTIFIER method_args LCURLY method_body RCURLY {
                  // TODO: change for class method specific stuff
                  ExpressionList_p body = new ExpressionList($5);
                  Method_p method = new Method(method_args, body);
                  // TODO: set method_args correctly
                  $$ = new MethodDefExpr(method_args, method);
                  method_args.clear();
                }
                ;

class_method_no_args: DEF IDENTIFIER IDENTIFIER LCURLY method_body RCURLY {
                  // TODO: change for class method specific stuff
                  ExpressionList_p body = new ExpressionList($5);
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
                | block_literal { $$ = $1; }
                ;

array_literal:  empty_array
                | LBRACKET exp_comma_list RBRACKET {
                    $$ = new ArrayLiteral($2);
                }
                ;

exp_comma_list: exp { $$ = expr_node($1, 0); }
                | exp COMMA exp_comma_list { $$ = expr_node($1, $3); }
                ;

empty_array:    LBRACKET RBRACKET { $$ = new ArrayLiteral(0); }
                ;

exp_list:       code { $$ = expr_node($1, 0); }
                | exp_list SEMI code { $$ = expr_node($3, $1); }
                ;

hash_literal:   LCURLY key_value_list RCURLY { $$ = new HashLiteral($2); }
                ;

block_literal:  LCURLY method_body RCURLY {
                  $$ = new BlockLiteral(new ExpressionList($2));
                }
                | STAB block_args STAB LCURLY method_body RCURLY {
                  $$ = new BlockLiteral(block_args, new ExpressionList($5));
                  block_args.clear();
                }
                ;

block_args:     IDENTIFIER { block_args.push_back($1); }
                | block_args COMMA IDENTIFIER { block_args.push_back($3); }
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
  
  fprintf(stderr, "ERROR [%s:%d] : %s at symbol %s\n", current_file.c_str(), yylineno, s, yytext);
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

expression_node* expr_node(Expression_p expr, expression_node *next)
{
  expression_node *node = new expression_node;
  node->expression = expr;
  node->next = next;
  return node;
}
