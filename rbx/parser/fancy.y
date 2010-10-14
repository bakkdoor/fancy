%{
#include "ruby.h"

extern VALUE fancy_parse_exception;
int yyerror(char *s);
int yylex(void);

%}

%union{
  VALUE object;
}

%start	programm

%token                  LPAREN
%token                  RPAREN
%token                  LCURLY
%token                  RCURLY
%token                  LBRACKET
%token                  RBRACKET
%token                  LHASH
%token                  RHASH
%token                  STAB
%token                  ARROW
%token                  COMMA
%token                  SEMI
%token                  NL
%token                  COLON
%token                  RETURN_LOCAL
%token                  RETURN
%token                  REQUIRE
%token                  TRY
%token                  CATCH
%token                  FINALLY
%token                  RETRY
%token                  SUPER
%token                  PRIVATE
%token                  PROTECTED
%token                  DEFCLASS
%token                  DEF
%token                  DOT
%token                  DOLLAR
%token                  EQUALS
%token                  RB_ARGS_PREFIX

%token <object>             INTEGER_LITERAL
%token <object>             DOUBLE_LITERAL
%token <object>             STRING_LITERAL
%token <object>             SYMBOL_LITERAL
%token <object>             REGEXP_LITERAL
%token <object>             IDENTIFIER
%token <object>             OPERATOR

%left                   DOT
%right                  DOLLAR

%type  <object>         literal_value
%type  <object>         block_literal
%type  <object>         block_args
%type  <object>         block_args_without_comma
%type  <object>         block_args_with_comma
%type  <object>         hash_literal
%type  <object>         array_literal
%type  <object>         empty_array

%type  <object>         key_value_list
%type  <object>         exp_comma_list
%type  <object>         method_body


%type  <object>         code
%type  <object>         exp
%type  <object>         assignment
%type  <object>         multiple_assignment
%type  <object>         identifier_list
%type  <object>         return_local_statement
%type  <object>         return_statement
%type  <object>         require_statement

%type  <object>         class_body
%type  <object>         class_def
%type  <object>         class_no_super
%type  <object>         class_super
%type  <object>         class_method_w_args
%type  <object>         class_method_no_args

%type  <object>         method_def
%type  <object>         method_w_args
%type  <object>         method_no_args
%type  <object>         operator_def
%type  <object>         class_operator_def

%type  <object>         message_send
%type  <object>         operator_send
%type  <object>         send_args
%type  <object>         receiver
%type  <object>         arg_exp

%type  <object>         try_catch_block
%type  <object>         catch_blocks
%type  <object>         finally_block
%type  <object>         catch_block_body

%%

programm:       /* empty */
                | code {
                  inspect($1);
                }
                | programm delim code {
                  inspect($3);
                }
                | programm delim { }
                ;

delim:          nls
                | SEMI
                | delim delim
                ;

nls:            NL
                | nls NL
                ;

space:          /* */
                | nls
                ;

code:           statement
                | exp
                ;

statement:      assignment
                | return_local_statement
                | return_statement
                | require_statement
                ;

exp:            method_def
                | class_def
                | message_send
                | operator_send
                | try_catch_block
                | literal_value
                | IDENTIFIER
                | LPAREN exp RPAREN { $$ = $2; }
                ;

assignment:     IDENTIFIER EQUALS space exp {
                  inspect($1);
                  inspect($4);
                }
                | multiple_assignment
                ;

multiple_assignment: identifier_list EQUALS exp_comma_list {
                  inspect($1);
                  inspect($3);
                }
                ;

identifier_list: IDENTIFIER { $$ = ident_node($1, NULL); }
                | identifier_list COMMA IDENTIFIER {
                  inspect($3);
                  inspect($1);
                }
                ;

return_local_statement: RETURN_LOCAL exp {
  //                  $$ = new nodes::ReturnStatement($2, true);
                }
                | RETURN_LOCAL {
  //             $$ = new nodes::ReturnStatement(nil, true);
                }
                ;

return_statement: RETURN exp {
                  $$ = new nodes::ReturnStatement($2);
                }
                | RETURN {
                  $$ = new nodes::ReturnStatement(nil);
                }
                ;

require_statement: REQUIRE STRING_LITERAL {
                  $$ = new nodes::RequireStatement($2);
                }
                | REQUIRE IDENTIFIER {
                  $$ = new nodes::RequireStatement($2);
                }
                ;

class_def:      class_no_super
                | class_super
                ;

class_no_super: DEFCLASS IDENTIFIER LCURLY class_body RCURLY {
                  $$ = new nodes::ClassDefExpr($2, new ExpressionList($4));
                }
                ;

class_super:    DEFCLASS IDENTIFIER COLON IDENTIFIER LCURLY class_body RCURLY {
                  $$ = new nodes::ClassDefExpr($4, $2, new ExpressionList($6));
                }
                ;

class_body:     /* empty */ { $$ = expr_node(0, 0); }
                | class_body class_def delim { $$ = expr_node(new nodes::NestedClassDefExpr($2), $1); }
                | class_body method_def delim { $$ = expr_node($2, $1); }
                | class_body code delim { $$ = expr_node($2, $1); }
                | class_body delim { } /* empty expressions */
                ;

method_def:     method_w_args
                | method_no_args
                | class_method_w_args
                | class_method_no_args
                | operator_def
                | class_operator_def
                ;

method_args:    IDENTIFIER COLON IDENTIFIER {
                  method_args.push_back(pair<nodes::Identifier*, nodes::Identifier*>($1, $3));
                }
                | method_args IDENTIFIER COLON IDENTIFIER {
                  method_args.push_back(pair<nodes::Identifier*, nodes::Identifier*>($2, $4));
                }
                ;

method_body:    /* empty */ { $$ = expr_node(0, 0); }
                | code { $$ = expr_node($1, 0); }
                | method_body delim code { $$ = expr_node($3, $1); }
                | method_body delim { } /* empty expressions */
                ;

method_w_args:  DEF method_args LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($5);
                  Method* method = new Method(method_args, body);
                  // TODO: set method_args correctly
                  $$ = new nodes::MethodDefExpr(method_args, method);
                  method_args.clear();
                }
                | DEF PRIVATE method_args LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($6);
                  Method* method = new Method(method_args, body);
                  // TODO: set method_args correctly
                  $$ = new nodes::PrivateMethodDefExpr(method_args, method);
                  method_args.clear();
                }
                | DEF PROTECTED method_args LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($6);
                  Method* method = new Method(method_args, body);
                  // TODO: set method_args correctly
                  $$ = new nodes::ProtectedMethodDefExpr(method_args, method);
                  method_args.clear();
                }
                ;


method_no_args: DEF IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($5);
                  list< pair<nodes::Identifier*, nodes::Identifier*> > empty_args;
                  Method* method = new Method(empty_args, body);
                  $$ = new nodes::MethodDefExpr($2, method);
                }
                | DEF PRIVATE IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($6);
                  list< pair<nodes::Identifier*, nodes::Identifier*> > empty_args;
                  Method* method = new Method(empty_args, body);
                  $$ = new nodes::PrivateMethodDefExpr($3, method);
                }
                | DEF PROTECTED IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($6);
                  list< pair<nodes::Identifier*, nodes::Identifier*> > empty_args;
                  Method* method = new Method(empty_args, body);
                  $$ = new nodes::ProtectedMethodDefExpr($3, method);
                }
                ;

class_method_w_args: DEF IDENTIFIER method_args LCURLY space method_body space RCURLY {
                  // TODO: change for class method specific stuff
                  ExpressionList* body = new ExpressionList($6);
                  Method* method = new Method(method_args, body);
                  // TODO: set method_args correctly
                  $$ = new nodes::ClassMethodDefExpr($2, method_args, method);
                  method_args.clear();
                }
                | DEF PRIVATE IDENTIFIER method_args LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($7);
                  Method* method = new Method(method_args, body);
                  $$ = new nodes::PrivateClassMethodDefExpr($3, method_args, method);
                  method_args.clear();
                }
                | DEF PROTECTED IDENTIFIER method_args LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($7);
                  Method* method = new Method(method_args, body);
                  $$ = new nodes::ProtectedClassMethodDefExpr($3, method_args, method);
                  method_args.clear();
                }
                ;

class_method_no_args: DEF IDENTIFIER IDENTIFIER LCURLY space method_body space RCURLY {
                  // TODO: change for class method specific stuff
                  ExpressionList* body = new ExpressionList($6);
                  list< pair<nodes::Identifier*, nodes::Identifier*> > empty_args;
                  Method* method = new Method(empty_args, body);
                  $$ = new nodes::ClassMethodDefExpr($2, $3, method);
                }
                | DEF PRIVATE IDENTIFIER IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($7);
                  list< pair<nodes::Identifier*, nodes::Identifier*> > empty_args;
                  Method* method = new Method(empty_args, body);
                  $$ = new nodes::PrivateClassMethodDefExpr($3, $4, method);
                }
                | DEF PROTECTED IDENTIFIER IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($7);
                  list< pair<nodes::Identifier*, nodes::Identifier*> > empty_args;
                  Method* method = new Method(empty_args, body);
                  $$ = new nodes::ProtectedClassMethodDefExpr($3, $4, method);
                }
                ;

operator_def:   DEF OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($6);
                  Method* method = new Method($2, $3, body);
                  $$ = new nodes::OperatorDefExpr($2, method);
                }
                | DEF PRIVATE OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($7);
                  Method* method = new Method($3, $4, body);
                  $$ = new nodes::PrivateOperatorDefExpr($3, method);
                }
                | DEF PROTECTED OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($7);
                  Method* method = new Method($3, $4, body);
                  $$ = new nodes::ProtectedOperatorDefExpr($3, method);
                }
                | DEF LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($7);
                  Method* method = new Method(nodes::Identifier::from_string("[]"), $4, body);
                  $$ = new nodes::OperatorDefExpr(nodes::Identifier::from_string("[]"), method);
                }
                | DEF PRIVATE LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($8);
                  Method* method = new Method(nodes::Identifier::from_string("[]"), $5, body);
                  $$ = new nodes::PrivateOperatorDefExpr(nodes::Identifier::from_string("[]"), method);
                }
                | DEF PROTECTED LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($8);
                  Method* method = new Method(nodes::Identifier::from_string("[]"), $5, body);
                  $$ = new nodes::ProtectedOperatorDefExpr(nodes::Identifier::from_string("[]"), method);
                }
                ;

class_operator_def: DEF IDENTIFIER OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($7);
                  Method* method = new Method($3, $4, body);
                  $$ = new nodes::ClassOperatorDefExpr($2, $3, method);
                }
                | DEF PRIVATE IDENTIFIER OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($8);
                  Method* method = new Method($4, $5, body);
                  $$ = new nodes::PrivateClassOperatorDefExpr($3, $4, method);
                }
                | DEF PROTECTED IDENTIFIER OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($8);
                  Method* method = new Method($4, $5, body);
                  $$ = new nodes::ProtectedClassOperatorDefExpr($3, $4, method);
                }
                | DEF IDENTIFIER LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($8);
                  Method* method = new Method(nodes::Identifier::from_string("[]"), $5, body);
                  $$ = new nodes::ClassOperatorDefExpr($2, nodes::Identifier::from_string("[]"), method);
                }
                | DEF PRIVATE IDENTIFIER LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($9);
                  Method* method = new Method(nodes::Identifier::from_string("[]"), $6, body);
                  $$ = new nodes::PrivateClassOperatorDefExpr($3, nodes::Identifier::from_string("[]"), method);
                }
                | DEF PROTECTED IDENTIFIER LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  ExpressionList* body = new ExpressionList($9);
                  Method* method = new Method(nodes::Identifier::from_string("[]"), $6, body);
                  $$ = new nodes::ProtectedClassOperatorDefExpr($3, nodes::Identifier::from_string("[]"), method);
                }
                ;

message_send:   receiver IDENTIFIER { $$ = new nodes::MessageSend($1, $2); }
                | receiver send_args {
                   $$ = new nodes::MessageSend($1, $2);
                }
                | send_args {
                   $$ = new nodes::MessageSend(nodes::Self::node(), $1);
                }
                ;


operator_send:  receiver OPERATOR arg_exp {
                  $$ = new nodes::OperatorSend($1, $2, $3);
                }
                | receiver OPERATOR DOT space arg_exp {
                  $$ = new nodes::OperatorSend($1, $2, $5);
                }
                | receiver LBRACKET exp RBRACKET {
                  $$ = new nodes::OperatorSend($1, nodes::Identifier::from_string("[]"), $3);
                }
                ;

receiver:       LPAREN space exp space RPAREN { $$ = $3; }
                | exp { $$ = $1; }
                | IDENTIFIER { $$ = $1; }
                | SUPER { $$ = new nodes::Super(); }
                | exp DOT space { $$ = $1; }
                ;

send_args:      IDENTIFIER COLON arg_exp { $$ = msend_arg_node($1, $3, 0); }
                | IDENTIFIER COLON space arg_exp { $$ = msend_arg_node($1, $4, 0); }
                | send_args IDENTIFIER COLON arg_exp { $$ = msend_arg_node($2, $4, $1); }
                | send_args IDENTIFIER COLON space arg_exp { $$ = msend_arg_node($2, $5, $1); }
                ;

arg_exp:        IDENTIFIER { $$ = $1; }
                | LPAREN exp RPAREN { $$ = $2; }
                | literal_value { $$ = $1; }
                | DOLLAR exp { $$ = $2; }
                ;

try_catch_block: TRY LCURLY method_body RCURLY catch_blocks {
                  ExpressionList* body = new ExpressionList($3);
                  $$ = new nodes::TryCatchBlock(body, $5);
                }
                | TRY LCURLY method_body RCURLY catch_blocks finally_block {
                  ExpressionList* body = new ExpressionList($3);
                  ExpressionList* finally = new ExpressionList($6);
                  $$ = new nodes::TryCatchBlock(body, $5, finally);
                }
                ;

catch_blocks:  /* empty */ { $$ = NULL; }
                | CATCH LCURLY catch_block_body RCURLY {
                  ExpressionList* body = new ExpressionList($3);
                  $$ = except_handler_node(nodes::Identifier::from_string("StdError"), NULL, body, NULL);
                }
                | CATCH IDENTIFIER LCURLY catch_block_body RCURLY {
                  ExpressionList* body = new ExpressionList($4);
                  $$ = except_handler_node($2, NULL, body, NULL);
                }
                | CATCH IDENTIFIER ARROW IDENTIFIER LCURLY catch_block_body RCURLY {
                  ExpressionList* body = new ExpressionList($6);
                  $$ = except_handler_node($2, $4, body, NULL);
                }
                | catch_blocks CATCH IDENTIFIER ARROW IDENTIFIER LCURLY catch_block_body RCURLY {
                  ExpressionList* body = new ExpressionList($7);
                  $$ = except_handler_node($3, $5, body, $1);
                }
                ;

catch_block_body: /* empty */ { $$ = expr_node(0, 0); }
                | code { $$ = expr_node($1, 0); }
                | RETRY { $$ = expr_node(new nodes::Retry(), 0); }
                | catch_block_body delim code { $$ = expr_node($3, $1); }
                | catch_block_body delim RETRY { $$ = expr_node(new nodes::Retry(), $1); }
                | catch_block_body delim { } /* empty expressions */
                ;

finally_block:  FINALLY LCURLY method_body RCURLY {
                  $$ = $3;
                }
                ;

literal_value:  INTEGER_LITERAL	{ $$ = $1; }
                | DOUBLE_LITERAL { $$ = $1; }
                | STRING_LITERAL { $$ = $1; }
                | SYMBOL_LITERAL { $$ = $1; }
                | hash_literal { $$ = $1; }
                | array_literal { $$ = $1; }
                | REGEXP_LITERAL { $$ = $1; }
                | block_literal { $$ = $1; }
                ;

array_literal:  empty_array
                | LBRACKET space exp_comma_list space RBRACKET {
                    $$ = new nodes::ArrayLiteral($3);
                }
                | RB_ARGS_PREFIX array_literal {
                  $$ = new nodes::RubyArgsLiteral($2);
                }
                ;

exp_comma_list: exp { $$ = expr_node($1, 0); }
                | exp_comma_list COMMA space exp { $$ = expr_node($4, $1); }
                | exp_comma_list COMMA { }
                ;

empty_array:    LBRACKET space RBRACKET { $$ = new nodes::ArrayLiteral(0); }
                ;

hash_literal:   LHASH space key_value_list space RHASH { $$ = new nodes::HashLiteral($3); }
                | LHASH space RHASH { $$ = new nodes::HashLiteral(0); }
                ;

block_literal:  LCURLY space method_body RCURLY {
                  $$ = new nodes::BlockLiteral(new ExpressionList($3));
                }
                | STAB block_args STAB space LCURLY space method_body space RCURLY {
                  $$ = new nodes::BlockLiteral($2, new ExpressionList($7));
                }
                ;

block_args:     block_args_with_comma
                | block_args_without_comma
                ;

block_args_without_comma: IDENTIFIER { $$ = blk_arg_node($1, 0); }
                | block_args IDENTIFIER { $$ = blk_arg_node($2, $1); }
                ;

block_args_with_comma: IDENTIFIER { $$ = blk_arg_node($1, 0); }
                | block_args COMMA IDENTIFIER { $$ = blk_arg_node($3, $1); }
                ;

key_value_list: SYMBOL_LITERAL space ARROW space exp { $$ = key_val_obj($1, $5, NULL); }
                | SYMBOL_LITERAL space ARROW space literal_value { $$ = key_val_obj($1, $5, NULL); }
                | STRING_LITERAL space ARROW space literal_value { $$ = key_val_obj($1, $5, NULL); }
                | key_value_list COMMA space SYMBOL_LITERAL space ARROW space exp  {
                  $$ = key_val_obj($4, $8, $1);
                }
                | key_value_list COMMA space STRING_LITERAL space ARROW space exp  {
                  $$ = key_val_obj($4, $8, $1);
                }
                | key_value_list COMMA space SYMBOL_LITERAL space ARROW space literal_value {
                  $$ = key_val_obj($4, $8, $1);
                }
                | key_value_list COMMA space SYMBOL_LITERAL space ARROW space literal_value {
                  $$ = key_val_obj($4, $8, $1);
                }
                ;

%%

void inspect(VALUE value)
{
  rb_funcall(value, rb_intern("p"), 1, value);
}

int yyerror(char *s)
{
  extern int yylineno;
  extern char *yytext;

  VALUE msg = rb_str_new2("Parse Error: ");
  msg = rb_str_concat(msg, rb_str_new2(current_file));
  msg = rb_str_concat(msg, rb_str_new2(":"));
  msg = rb_str_concat(msg, rb_funcall(INT2NUM(yylineno), rb_intern("to_s")));
  msg = rb_str_concat(msg, rb_str_new2(" at symbol '"));
  msg = rb_str_concat(msg, rb_str_new2(yytext));
  msg = rb_str_concat(msg, rb_str_new2("'"));

  rb_funcall(msg, rb_intern("raise"), 1, msg);
  return 1;
}

