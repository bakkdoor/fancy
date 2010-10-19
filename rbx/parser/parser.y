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
%token                  CLASS
%token                  DEF
%token                  DOT
%token                  DOLLAR
%token                  EQUALS
%token                  RB_ARGS_PREFIX
%token                  IDENTIFIER
%token                  CLASS_IDENTIFIER
%token                  CLASS_NESTED

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
%type  <object>         class_identifier
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
%type  <object>         method_args
%type  <object>         method_w_args
%type  <object>         method_no_args
%type  <object>         operator_def
%type  <object>         class_operator_def

%type  <object>         message_send
%type  <object>         ruby_send
%type  <object>         ruby_args
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
                | ruby_send
                | try_catch_block
                | literal_value
                | identifier
                | LPAREN exp RPAREN { $$ = $2; }
                ;

assignment:     identifier EQUALS space exp {
                  $$ = rb_funcall(m_Parser, rb_intern("assignment"), 3, INT2NUM(yylineno), $1, $4);
                }
                | multiple_assignment
                ;

multiple_assignment: identifier_list EQUALS exp_comma_list {
                  $$ = rb_funcall(m_Parser, rb_intern("multiple_assignment"), 3, INT2NUM(yylineno), $1, $3);
                }
                ;

operator:       OPERATOR {
                  $$ = fy_terminal_node("identifier");
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
                  $$ = rb_funcall(m_Parser, rb_intern("identifier_list"), 3, INT2NUM(yylineno), $1, $3);
                }
                ;

return_local_statement: RETURN_LOCAL exp {
                  $$ = rb_funcall(m_Parser, rb_intern("return_local"), 2, INT2NUM(yylineno), $2);
                }
                | RETURN_LOCAL {
                  $$ = rb_funcall(m_Parser, rb_intern("return_local"), 1, INT2NUM(yylineno));
                }
                ;

return_statement: RETURN exp {
                  $$ = rb_funcall(m_Parser, rb_intern("return_stmt"), 2, INT2NUM(yylineno), $2);
                }
                | RETURN {
                  $$ = rb_funcall(m_Parser, rb_intern("return_stmt"), 1, INT2NUM(yylineno));
                }
                ;

require_statement: REQUIRE string_literal {
                  $$ = rb_funcall(m_Parser, rb_intern("require_stmt"), 2, INT2NUM(yylineno), $2);
                }
                | REQUIRE identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("require_stmt"), 2, INT2NUM(yylineno), $2);
                }
                ;

class_def:      class_no_super
                | class_super
                ;

class_identifier: CLASS_IDENTIFIER |
                  CLASS_NESTED {
                  $$ = fy_terminal_node("identifier");
                }
                ;

class_no_super: CLASS class_identifier LCURLY class_body RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("class_def"), 4, INT2NUM(yylineno), $2, Qnil, $4);
                }
                ;

class_super:    CLASS class_identifier COLON identifier LCURLY class_body RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("class_def"), 4, INT2NUM(yylineno), $2, $4, $6);
                }
                ;

class_body:     /* empty */ {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_list"), 1, INT2NUM(yylineno));
                }
                | class_body class_def delim {
                  rb_funcall($1, rb_intern("add_expression"), 1, $2);
                  $$ = $1;
                }
                | class_body method_def delim {
                  rb_funcall($1, rb_intern("add_expression"), 1, $2);
                  $$ = $1;
                }
                | class_body code delim {
                  rb_funcall($1, rb_intern("add_expression"), 1, $2);
                  $$ = $1;
                }
                | class_body delim {
                  $$ = $1;
                } /* empty expressions */
                ;

method_def:     method_w_args
                | method_no_args
                | class_method_w_args
                | class_method_no_args
                | operator_def
                | class_operator_def
                ;

method_args:    identifier COLON identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("method_args"), 3, INT2NUM(yylineno), $1, $3);
                }
                | method_args identifier COLON identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("method_args"), 4, INT2NUM(yylineno), $2, $4, $1);
                }
                ;

method_body:    /* empty */ {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_list"), 1, INT2NUM(yylineno));
                }
                | code {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_list"), 2, INT2NUM(yylineno), $1);
                }
                | method_body delim code {
                  $$ = rb_funcall(m_Parser, rb_intern("method_body"), 3, INT2NUM(yylineno), $1, $3);
                }
                | method_body delim { } /* empty expressions */
                ;

method_w_args:  DEF method_args LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("method_def"), 3, INT2NUM(yylineno), $2, $5);
                }
                | DEF PRIVATE method_args LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("method_def"), 4, INT2NUM(yylineno), $3, $6, rb_intern("private"));
                }
                | DEF PROTECTED method_args LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("method_def"), 4, INT2NUM(yylineno), $3, $6, rb_intern("protected"));
                }
                ;


method_no_args: DEF identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("method_def_no_args"), 3, INT2NUM(yylineno), $2, $5);
                }
                | DEF PRIVATE identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("method_def_no_args"), 4, INT2NUM(yylineno), $3, $6, rb_intern("private"));
                }
                | DEF PROTECTED identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("method_def_no_args"), 4, INT2NUM(yylineno), $3, $6, rb_intern("protected"));
                }
                ;

class_method_w_args: DEF identifier method_args LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_method_def"), 4, INT2NUM(yylineno), $2, $3, $6);
                }
                | DEF PRIVATE identifier method_args LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_method_def"), 5, INT2NUM(yylineno), $3, $4, $7, rb_intern("private"));
                }
                | DEF PROTECTED identifier method_args LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_method_def"), 5, INT2NUM(yylineno), $3, $4, $7, rb_intern("protected"));
                }
                ;

class_method_no_args: DEF identifier identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_method_def_no_args"), 4, INT2NUM(yylineno), $2, $3, $6);
                }
                | DEF PRIVATE identifier identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_method_def_no_args"), 5, INT2NUM(yylineno), $3, $4, $7, rb_intern("private"));
                }
                | DEF PROTECTED identifier identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_method_def_no_args"), 5, INT2NUM(yylineno), $3, $4, $7, rb_intern("protected"));
                }
                ;

operator_def:   DEF operator identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("operator_def"), 4, INT2NUM(yylineno), $2, $3, $6);
                }
                | DEF PRIVATE operator identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("operator_def"), 5, INT2NUM(yylineno), $3, $4, $7, rb_intern("private"));
                }
                | DEF PROTECTED operator identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("operator_def"), 5, INT2NUM(yylineno), $3, $4, $7, rb_intern("protected"));
                }
                | DEF LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("operator_def"), 4, INT2NUM(yylineno), fy_terminal_node_from("identifier", "[]"), $4, $7);
                }
                | DEF PRIVATE LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("operator_def"), 5, INT2NUM(yylineno), fy_terminal_node_from("identifier", "[]"), $5, $8, rb_intern("private"));
                }
                | DEF PROTECTED LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("operator_def"), 5, INT2NUM(yylineno), fy_terminal_node_from("identifier", "[]"), $5, $8, rb_intern("protected"));
                }
                ;

class_operator_def: DEF identifier operator identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_operator_def"), 5, INT2NUM(yylineno), $2, $3, $4, $7);
                }
                |DEF PRIVATE identifier operator identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_operator_def"), 6, INT2NUM(yylineno), $3, $4, $5, $8, rb_intern("private"));
                }
                | DEF PROTECTED identifier operator identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_operator_def"), 6, INT2NUM(yylineno), $3, $4, $5, $8, rb_intern("protected"));
                }
                | DEF identifier LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_operator_def"), 5, INT2NUM(yylineno), $2, fy_terminal_node_from("identifier", "[]"), $5, $8);
                }
                | DEF PRIVATE identifier LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_operator_def"), 6, INT2NUM(yylineno), $3, fy_terminal_node_from("identifier", "[]"), $6, $9, rb_intern("private"));
                }
                | DEF PROTECTED identifier LBRACKET RBRACKET identifier LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_operator_def"), 6, INT2NUM(yylineno), $3, fy_terminal_node_from("identifier", "[]"), $6, $9, rb_intern("protected"));
                }
                ;

message_send:   receiver identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("msg_send_basic"), 3, INT2NUM(yylineno), $1, $2);
                }
                | receiver send_args {
                  $$ = rb_funcall(m_Parser, rb_intern("msg_send_args"), 3, INT2NUM(yylineno), $1, $2);
                }
                | send_args {
                  $$ = rb_funcall(m_Parser, rb_intern("msg_send_args"), 3, INT2NUM(yylineno), Qnil, $1);
                }
                ;

ruby_send:      receiver identifier ruby_args {
                  $$ = rb_funcall(m_Parser, rb_intern("msg_send_ruby"), 4, INT2NUM(yylineno), $1, $2, $3);
                }
                | identifier ruby_args {
                  $$ = rb_funcall(m_Parser, rb_intern("msg_send_ruby"), 4, INT2NUM(yylineno), Qnil, $1, $2);
                }
                ;

ruby_args:      LPAREN RPAREN block_literal  {
                  $$ = rb_funcall(m_Parser, rb_intern("ruby_args"), 3, INT2NUM(yylineno), Qnil, $3);
                }
                | LPAREN exp_comma_list RPAREN block_literal {
                  $$ = rb_funcall(m_Parser, rb_intern("ruby_args"), 3, INT2NUM(yylineno), $2, $4);
                }
                | LPAREN RPAREN {
                  $$ = rb_funcall(m_Parser, rb_intern("ruby_args"), 1, INT2NUM(yylineno));
                }
                | LPAREN exp_comma_list RPAREN {
                  $$ = rb_funcall(m_Parser, rb_intern("ruby_args"), 2, INT2NUM(yylineno), $2);
                }
                | block_literal {
                  $$ = rb_funcall(m_Parser, rb_intern("ruby_args"), 3, INT2NUM(yylineno), Qnil, $1);
                }
                ;

operator_send:  receiver operator arg_exp {
                  $$ = rb_funcall(m_Parser, rb_intern("oper_send_basic"), 4, INT2NUM(yylineno), $1, $2, $3);
                }
                | receiver operator DOT space arg_exp {
                  $$ = rb_funcall(m_Parser, rb_intern("oper_send_basic"), 4, INT2NUM(yylineno), $1, $2, $5);
                }
                | receiver LBRACKET exp RBRACKET {
                  $$ = rb_funcall(m_Parser, rb_intern("oper_send_basic"), 4, INT2NUM(yylineno), $1, fy_terminal_node_from("identifier", "[]"), $3);
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
                  $$ = rb_funcall(m_Parser, rb_intern("super_exp"), 1, INT2NUM(yylineno));
                }
                | exp DOT space {
                  $$ = $1;
                }
                ;

send_args:      identifier COLON arg_exp {
                  $$ = rb_funcall(m_Parser, rb_intern("send_args"), 3, INT2NUM(yylineno), $1, $3);
                }
                | identifier COLON space arg_exp {
                  $$ = rb_funcall(m_Parser, rb_intern("send_args"), 3, INT2NUM(yylineno), $1, $4);
                }
                | send_args identifier COLON arg_exp {
                  $$ = rb_funcall(m_Parser, rb_intern("send_args"), 4, INT2NUM(yylineno), $2, $4, $1);
                }
                | send_args identifier COLON space arg_exp {
                  $$ = rb_funcall(m_Parser, rb_intern("send_args"), 4, INT2NUM(yylineno), $2, $5, $1);
                }
                ;

arg_exp:        identifier {
                  $$ = $1;
                }
                | LPAREN exp RPAREN {
                  $$ = $2;
                }
                | literal_value {
                  $$ = $1;
                }
                | DOLLAR exp {
                  $$ = $2;
                }
                ;

try_catch_block: TRY LCURLY method_body RCURLY catch_blocks {
                  $$ = rb_funcall(m_Parser, rb_intern("try_catch_finally"), 3, INT2NUM(yylineno), $3, $5);
                }
                | TRY LCURLY method_body RCURLY catch_blocks finally_block {
                  $$ = rb_funcall(m_Parser, rb_intern("try_catch_finally"), 4, INT2NUM(yylineno), $3, $5, $6);
                }
                ;

catch_blocks:  /* empty */ {
                  $$ = Qnil;
                }
                | CATCH LCURLY catch_block_body RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handler"), 2, INT2NUM(yylineno), $3);
                }
                | CATCH exp LCURLY catch_block_body RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handler"), 3, INT2NUM(yylineno), $4, $2);
                }
                | CATCH exp ARROW identifier LCURLY catch_block_body RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handler"), 4, INT2NUM(yylineno), $6, $2, $4);
                }
                | catch_blocks CATCH identifier ARROW identifier LCURLY catch_block_body RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handler"), 5, INT2NUM(yylineno), $7, $3, $5, $1);
                }
                ;

catch_block_body: /* empty */ {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_list"), 1, INT2NUM(yylineno));
                }
                | code {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_list"), 2, INT2NUM(yylineno), $1);
                }
                | RETRY {
                  VALUE retry = rb_funcall(m_Parser, rb_intern("retry_exp"), 1, INT2NUM(yylineno));
                  $$ = rb_funcall(m_Parser, rb_intern("expr_list"), 2, INT2NUM(yylineno), retry);
                }
                | catch_block_body delim code {
                  rb_funcall($1, rb_intern("add_expression"), 1, $3);
                  $$ = $1;
                }
                | catch_block_body delim RETRY {
                  VALUE retry = rb_funcall(m_Parser, rb_intern("retry_exp"), 1, INT2NUM(yylineno));
                  rb_funcall($1, rb_intern("add_expression"), 1, retry);
                  $$ = $1;
                }
                | catch_block_body delim {
                  $$ = $1;
                } /* empty expressions */
                ;

finally_block:  FINALLY LCURLY method_body RCURLY {
                  $$ = $3;
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
                | symbol_literal
                | hash_literal
                | array_literal
                | regex_literal
                | block_literal
                ;

array_literal:  empty_array {
                  $$ = $1;
                }
                | LBRACKET space exp_comma_list space RBRACKET {
                  $$ = rb_funcall(m_Parser, rb_intern("array_literal"), 2, INT2NUM(yylineno), $3);
                }
                | RB_ARGS_PREFIX array_literal {
                  $$ = rb_funcall(m_Parser, rb_intern("ruby_args"), 2, INT2NUM(yylineno), $2);
                }
                ;

exp_comma_list: exp {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_ary"), 2, INT2NUM(yylineno), $1);
                }
                | exp_comma_list COMMA space exp {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_ary"), 3, INT2NUM(yylineno), $4, $1);
                }
                | exp_comma_list COMMA {
                  $$ = $1;
                }
                ;

empty_array:    LBRACKET space RBRACKET {
                  $$ = rb_funcall(m_Parser, rb_intern("array_literal"), 1, INT2NUM(yylineno));
                }
                ;

hash_literal:   LHASH space key_value_list space RHASH {
                  $$ = rb_funcall(m_Parser, rb_intern("hash_literal"), 2, INT2NUM(yylineno), $3);
                }
                | LHASH space RHASH {
                  $$ = rb_funcall(m_Parser, rb_intern("hash_literal"), 2, INT2NUM(yylineno));
                }
                ;

block_literal:  LCURLY space method_body RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("block_literal"), 3, INT2NUM(yylineno), Qnil, $3);
                }
                | STAB block_args STAB space LCURLY space method_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("block_literal"), 3, INT2NUM(yylineno), $2, $7);
                }
                ;

block_args:     block_args_with_comma
                | block_args_without_comma
                ;

block_args_without_comma: identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("block_args"), 2, INT2NUM(yylineno), $1);
                }
                | block_args identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("block_args"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

block_args_with_comma: identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("block_args"), 2, INT2NUM(yylineno), $1);
                }
                | block_args COMMA identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("block_args"), 3, INT2NUM(yylineno), $3, $1);
                }
                ;

key_value_list: exp space ARROW space exp {
                  $$ = rb_funcall(m_Parser, rb_intern("key_value_list"), 3, INT2NUM(yylineno), $1, $5);
                }
                | key_value_list COMMA space exp space ARROW space exp {
                  $$ = rb_funcall(m_Parser, rb_intern("key_value_list"), 4, INT2NUM(yylineno), $4, $8, $1);
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

