%{
#include "ruby.h"

int yyerror(char *s);
int yylex(void);

VALUE fy_terminal_node(char *);

extern int yylineno;
extern char *yytext;
extern VALUE m_Parser;

%}

%union{
  VALUE object;
  ID    symbol;
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

%token <object>         INTEGER_LITERAL
%token <object>         DOUBLE_LITERAL
%token <object>         STRING_LITERAL
%token <object>         SYMBOL_LITERAL
%token <object>         REGEXP_LITERAL
%token <object>         IDENTIFIER
%token <object>         OPERATOR

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
                  rb_funcall(m_Parser, rb_intern("add_expr"), 1, $1);
                }
                | programm delim code {
                  rb_funcall(m_Parser, rb_intern("add_expr"), 1, $3);
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
                  $$ = Qnil;
                }
                | multiple_assignment
                ;

multiple_assignment: identifier_list EQUALS exp_comma_list {
                  $$ = Qnil;
                }
                ;

identifier_list: IDENTIFIER {
                  $$ = Qnil;
                }
                | identifier_list COMMA IDENTIFIER {
                  $$ = Qnil;
                }
                ;

return_local_statement: RETURN_LOCAL exp {
                  $$ = Qnil;
                }
                | RETURN_LOCAL {
                  $$ = Qnil;
                }
                ;

return_statement: RETURN exp {
                  $$ = Qnil;
                }
                | RETURN {
                  $$ = Qnil;
                }
                ;

require_statement: REQUIRE STRING_LITERAL {
                  $$ = Qnil;
                }
                | REQUIRE IDENTIFIER {
                  $$ = Qnil;
                }
                ;

class_def:      class_no_super
                | class_super
                ;

class_no_super: DEFCLASS IDENTIFIER LCURLY class_body RCURLY {
                  $$ = Qnil;
                }
                ;

class_super:    DEFCLASS IDENTIFIER COLON IDENTIFIER LCURLY class_body RCURLY {
                  $$ = Qnil;
                }
                ;

class_body:     /* empty */ {
                  $$ = Qnil;
                }
                | class_body class_def delim {
                  $$ = Qnil;
                }
                | class_body method_def delim {
                  $$ = Qnil;
                }
                | class_body code delim {
                  $$ = Qnil;
                }
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
                }
                | method_args IDENTIFIER COLON IDENTIFIER {
                }
                ;

method_body:    /* empty */ { $$ = Qnil; }
                | code { $$ = Qnil; }
                | method_body delim code { $$ = Qnil; }
                | method_body delim { } /* empty expressions */
                ;

method_w_args:  DEF method_args LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE method_args LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED method_args LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;


method_no_args: DEF IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

class_method_w_args: DEF IDENTIFIER method_args LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE IDENTIFIER method_args LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED IDENTIFIER method_args LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

class_method_no_args: DEF IDENTIFIER IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE IDENTIFIER IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED IDENTIFIER IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

operator_def:   DEF OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                   $$ = Qnil;
                }
                | DEF LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

class_operator_def: DEF IDENTIFIER OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                |DEF PRIVATE IDENTIFIER OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED IDENTIFIER OPERATOR IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF IDENTIFIER LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE IDENTIFIER LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED IDENTIFIER LBRACKET RBRACKET IDENTIFIER LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

message_send:   receiver IDENTIFIER {
                  $$ = Qnil;
                }
                | receiver send_args {
                  $$ = Qnil;
                }
                | send_args {
                  $$ = Qnil;

                }
                ;


operator_send:  receiver OPERATOR arg_exp {
                  $$ = Qnil;
                }
                | receiver OPERATOR DOT space arg_exp {
                  $$ = Qnil;
                }
                | receiver LBRACKET exp RBRACKET {
                  $$ = Qnil;
                }
                ;

receiver:       LPAREN space exp space RPAREN {
                  $$ = Qnil;
                }
                | exp {
                  $$ = Qnil;
                }
                | IDENTIFIER {
                  $$ = Qnil;
                }
                | SUPER {
                  $$ = Qnil;
                }
                | exp DOT space {
                  $$ = Qnil;
                }
                ;

send_args:      IDENTIFIER COLON arg_exp {
                  $$ = Qnil;
                }
                | IDENTIFIER COLON space arg_exp {
                  $$ = Qnil;
                }
                | send_args IDENTIFIER COLON arg_exp {
                  $$ = Qnil;
                }
                | send_args IDENTIFIER COLON space arg_exp {
                  $$ = Qnil;
                }
                ;

arg_exp:        IDENTIFIER {
                  $$ = Qnil;
                }
                | LPAREN exp RPAREN {
                  $$ = Qnil;
                }
                | literal_value {
                  $$ = Qnil;

                }
                | DOLLAR exp {
                  $$ = Qnil;
                }
                ;

try_catch_block: TRY LCURLY method_body RCURLY catch_blocks {
                  $$ = Qnil;
                }
                | TRY LCURLY method_body RCURLY catch_blocks finally_block {
                  $$ = Qnil;
                }
                ;

catch_blocks:  /* empty */ {
                  $$ = Qnil
                }
                | CATCH LCURLY catch_block_body RCURLY {
                  $$ = Qnil;
                }
                | CATCH IDENTIFIER LCURLY catch_block_body RCURLY {
                  $$ = Qnil;
                }
                | CATCH IDENTIFIER ARROW IDENTIFIER LCURLY catch_block_body RCURLY {
                  $$ = Qnil;
                }
                | catch_blocks CATCH IDENTIFIER ARROW IDENTIFIER LCURLY catch_block_body RCURLY {
                  $$ = Qnil;
                }
                ;

catch_block_body: /* empty */ {
                  $$ = Qnil
                }
                | code {
                  $$ = Qnil;

                }
                | RETRY {
                  $$ = Qnil;

                }
                | catch_block_body delim code {
                  $$ = Qnil;
                }
                | catch_block_body delim RETRY {
                  $$ = Qnil;
                }
                | catch_block_body delim {
                  $$ = Qnil;
                } /* empty expressions */
                ;

finally_block:  FINALLY LCURLY method_body RCURLY {
                  $$ = Qnil;
                }
                ;

literal_value:  INTEGER_LITERAL	{
                  $$ = fy_terminal_node("integer_literal");
                }
                | DOUBLE_LITERAL {
                  $$ = fy_terminal_node("double_literal");
                }
                | STRING_LITERAL {
                  $$ = fy_terminal_node("string_literal");
                }
                | SYMBOL_LITERAL {
                  $$ = fy_terminal_node("symbol_literal");
                }
                | hash_literal {
                  $$ = Qnil;
                }
                | array_literal {
                  $$ = Qnil;
                  }
                | REGEXP_LITERAL {
                  $$ = Qnil;
                }
                | block_literal {
                  $$ = Qnil;
                }
                ;

array_literal:  empty_array
                | LBRACKET space exp_comma_list space RBRACKET {
                  $$ = Qnil;
                }
                | RB_ARGS_PREFIX array_literal {
                  $$ = Qnil;
                }
                ;

exp_comma_list: exp {
                  $$ = Qnil;
                }
                | exp_comma_list COMMA space exp {
                  $$ = Qnil;
                }
                | exp_comma_list COMMA { }
                ;

empty_array:    LBRACKET space RBRACKET {
                  $$ = Qnil;
                }
                ;

hash_literal:   LHASH space key_value_list space RHASH {
                  $$ = Qnil;
                }
                | LHASH space RHASH {
                  $$ = Qnil;
                }
                ;

block_literal:  LCURLY space method_body RCURLY {
                  $$ = Qnil;
                }
                | STAB block_args STAB space LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

block_args:     block_args_with_comma
                | block_args_without_comma
                ;

block_args_without_comma: IDENTIFIER {
                  $$ = Qnil;
                }
                | block_args IDENTIFIER {
                  $$ = Qnil;
                }
                ;

block_args_with_comma: IDENTIFIER {
                  $$ = Qnil;
                }
                | block_args COMMA IDENTIFIER {
                  $$ = Qnil;
                }
                ;

key_value_list: SYMBOL_LITERAL space ARROW space exp {
                  $$ = Qnil;
                }
                | SYMBOL_LITERAL space ARROW space literal_value {
                  $$ = Qnil;
                }
                | STRING_LITERAL space ARROW space literal_value {
                  $$ = Qnil;
                }
                | key_value_list COMMA space SYMBOL_LITERAL space ARROW space exp  {
                  $$ = Qnil;
                }
                | key_value_list COMMA space STRING_LITERAL space ARROW space exp  {
                  $$ = Qnil;
                }
                | key_value_list COMMA space SYMBOL_LITERAL space ARROW space literal_value {
                  $$ = Qnil;
                }
                | key_value_list COMMA space SYMBOL_LITERAL space ARROW space literal_value {
                  $$ = Qnil;
                }
                ;

%%

VALUE fy_terminal_node(char* method) {
  return rb_funcall(m_Parser, rb_intern(method), 2, INT2NUM(yylineno), rb_str_new2(yytext));
}

int yyerror(char *s)
{
  rb_funcall(m_Parser, rb_intern("parse_error"), 2, INT2NUM(yylineno), rb_str_new2(yytext));
  return 1;
}

