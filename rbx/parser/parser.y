%{
#include "ruby.h"

int yyerror(char *s);
int yylex(void);

VALUE fy_terminal_node(char *);
VALUE fy_terminal_node_from(char *, char*);

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
%token                  IDENTIFIER

%token                  INTEGER_LITERAL
%token                  DOUBLE_LITERAL
%token                  STRING_LITERAL
%token                  SYMBOL_LITERAL
%token                  REGEX_LITERAL
%token                  OPERATOR

%left                   DOT
%right                  DOLLAR

%type <object>          integer_literal
%type <object>          double_literal
%type <object>          string_literal
%type <object>          symbol_literal
%type <object>          regex_literal
%type <object>          operator


%type  <object>         identifier
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
                | identifier
                | LPAREN exp RPAREN { $$ = $2; }
                ;

assignment:     identifier EQUALS space exp {
                  $$ = rb_funcall(m_Parser, rb_intern("assignment"), 2, $1, $4);
                }
                | multiple_assignment
                ;

multiple_assignment: identifier_list EQUALS exp_comma_list {
                  $$ = rb_funcall(m_Parser, rb_intern("multiple_assignment"), 2, $1, $3);
                }
                ;

operator:       OPERATOR {
                  $$ = fy_terminal_node("operator");
                }
                ;

identifier:     IDENTIFIER {
                  $$ = fy_terminal_node("identifier");
                }
                ;

identifier_list: identifier {
                  $$ = $1;
                }
                | identifier_list COMMA identifier {
                  $$ = Qnil;
                }
                ;

return_local_statement: RETURN_LOCAL exp {
                  $$ = rb_funcall(m_Parser, rb_intern("return_local"), 1, $2);
                }
                | RETURN_LOCAL {
                  $$ = rb_funcall(m_Parser, rb_intern("return_local"), 1, Qnil);
                }
                ;

return_statement: RETURN exp {
                  $$ = rb_funcall(m_Parser, rb_intern("return_stmt"), 1, $2);
                }
                | RETURN {
                  $$ = rb_funcall(m_Parser, rb_intern("return_stmt"), 1, Qnil);
                }
                ;

require_statement: REQUIRE string_literal {
                  $$ = rb_funcall(m_Parser, rb_intern("require_stmt"), 1, $2);
                }
                | REQUIRE identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("require_stmt"), 1, $2);
                }
                ;

class_def:      class_no_super
                | class_super
                ;

class_no_super: DEFCLASS identifier LCURLY class_body RCURLY {
                  $$ = Qnil;
                }
                ;

class_super:    DEFCLASS identifier COLON identifier LCURLY class_body RCURLY {
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

method_args:    identifier COLON identifier {
                }
                | method_args identifier COLON identifier {
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


method_no_args: DEF identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

class_method_w_args: DEF identifier method_args LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE identifier method_args LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED identifier method_args LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

class_method_no_args: DEF identifier identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE identifier identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED identifier identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

operator_def:   DEF operator identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE operator identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED operator identifier LCURLY space method_body space RCURLY {
                   $$ = Qnil;
                }
                | DEF LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

class_operator_def: DEF identifier operator identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                |DEF PRIVATE identifier operator identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED identifier operator identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF identifier LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PRIVATE identifier LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                | DEF PROTECTED identifier LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = Qnil;
                }
                ;

message_send:   receiver identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("msg_send_basic"), 3, INT2NUM(yylineno), $1, $2);
                }
                | receiver send_args {
                  $$ = Qnil;
                }
                | send_args {
                  $$ = Qnil;

                }
                ;


operator_send:  receiver operator arg_exp {
                  $$ = Qnil;
                }
                | receiver operator DOT space arg_exp {
                  $$ = Qnil;
                }
                | receiver LBRACKET exp RBRACKET {
                  $$ = Qnil;
                }
                ;

receiver:       LPAREN space exp space RPAREN {
                  $$ = $3;
                }
                | exp
                | identifier {
                  $$ = $1;
                }
                | SUPER {
                  $$ = rb_funcall(m_Parser, rb_intern("super_exp"), 0);
                }
                | exp DOT space {
                  $$ = $1;
                }
                ;

send_args:      identifier COLON arg_exp {
                  $$ = Qnil;
                }
                | identifier COLON space arg_exp {
                  $$ = Qnil;
                }
                | send_args identifier COLON arg_exp {
                  $$ = Qnil;
                }
                | send_args identifier COLON space arg_exp {
                  $$ = Qnil;
                }
                ;

arg_exp:        identifier
                | LPAREN exp RPAREN {
                  $$ = $2;
                }
                | literal_value
                | DOLLAR exp {
                  $$ = $2;
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
                | CATCH identifier LCURLY catch_block_body RCURLY {
                  $$ = Qnil;
                }
                | CATCH identifier ARROW identifier LCURLY catch_block_body RCURLY {
                  $$ = Qnil;
                }
                | catch_blocks CATCH identifier ARROW identifier LCURLY catch_block_body RCURLY {
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

integer_literal: INTEGER_LITERAL {
                  $$ = fy_terminal_node("integer_literal");
                }
                ;
double_literal: DOUBLE_LITERAL {
                  $$ = fy_terminal_node("double_literal");
                }
                ;
string_literal: STRING_LITERAL {
                  $$ = fy_terminal_node("string_literal");
                }
                ;
symbol_literal: SYMBOL_LITERAL {
                  $$ = fy_terminal_node("symbol_literal");
                }
                ;
regex_literal: REGEX_LITERAL {
                  $$ = fy_terminal_node("regex_literal");
                }
                ;

literal_value:  integer_literal
                | double_literal
                | string_literal
                | symbol_literal {
                  $$ = $1;
                }
                | hash_literal {
                  $$ = Qnil;
                }
                | array_literal {
                  $$ = Qnil;
                  }
                | regex_literal {
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

block_args_without_comma: identifier {
                  $$ = Qnil;
                }
                | block_args identifier {
                  $$ = Qnil;
                }
                ;

block_args_with_comma: identifier {
                  $$ = Qnil;
                }
                | block_args COMMA identifier {
                  $$ = Qnil;
                }
                ;

key_value_list: symbol_literal space ARROW space exp {
                  $$ = Qnil;
                }
                | symbol_literal space ARROW space literal_value {
                  $$ = Qnil;
                }
                | string_literal space ARROW space literal_value {
                  $$ = Qnil;
                }
                | key_value_list COMMA space symbol_literal space ARROW space exp  {
                  $$ = Qnil;
                }
                | key_value_list COMMA space string_literal space ARROW space exp  {
                  $$ = Qnil;
                }
                | key_value_list COMMA space symbol_literal space ARROW space literal_value {
                  $$ = Qnil;
                }
                | key_value_list COMMA space symbol_literal space ARROW space literal_value {
                  $$ = Qnil;
                }
                ;

%%

VALUE fy_terminal_node(char* method) {
  return rb_funcall(m_Parser, rb_intern(method), 2, INT2NUM(yylineno), rb_str_new2(yytext));
}

VALUE fy_terminal_node_from(char* method, char* text) {
  return rb_funcall(m_Parser, rb_intern(method), 2, INT2NUM(yylineno), rb_str_new2(text));
}

int yyerror(char *s)
{
  rb_funcall(m_Parser, rb_intern("parse_error"), 2, INT2NUM(yylineno), rb_str_new2(yytext));
  return 1;
}

