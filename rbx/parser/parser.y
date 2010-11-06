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
%token                  THIN_ARROW
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
%token                  MATCH
%token                  CASE
%token                  IDENTIFIER
%token                  CONSTANT

%token                  INTEGER_LITERAL
%token                  HEX_LITERAL
%token                  OCT_LITERAL
%token                  BIN_LITERAL
%token                  DOUBLE_LITERAL
%token                  STRING_LITERAL
%token                  MULTI_STRING_LITERAL
%token                  SYMBOL_LITERAL
%token                  REGEX_LITERAL
%token                  OPERATOR

%left                   DOT
%right                  DOLLAR

%type <object>          integer_literal
%type <object>          hex_literal
%type <object>          oct_literal
%type <object>          bin_literal
%type <object>          double_literal
%type <object>          string_literal
%type <object>          symbol_literal
%type <object>          regex_literal
%type <object>          operator


%type  <object>         identifier
%type  <object>         any_identifier
%type  <object>         constant
%type  <object>         literal_value
%type  <object>         block_literal
%type  <object>         block_args
%type  <object>         block_args_without_comma
%type  <object>         block_args_with_comma
%type  <object>         hash_literal
%type  <object>         array_literal
%type  <object>         empty_array
%type  <object>         tuple_literal
%type  <object>         range_literal

%type  <object>         key_value_list
%type  <object>         exp_comma_list

%type  <object>         code
%type  <object>         expression_list
%type  <object>         expression_block
%type  <object>         exp
%type  <object>         assignment
%type  <object>         multiple_assignment
%type  <object>         identifier_list
%type  <object>         return_local_statement
%type  <object>         return_statement
%type  <object>         require_statement

%type  <object>         def

%type  <object>         const_identifier
%type  <object>         class_def
%type  <object>         class_no_super
%type  <object>         class_super
%type  <object>         class_method_w_args
%type  <object>         class_method_no_args

%type  <object>         method_def
%type  <object>         method_args
%type  <object>         method_arg
%type  <object>         method_args_default
%type  <object>         method_arg_default
%type  <object>         method_w_args
%type  <object>         method_no_args
%type  <object>         operator_def
%type  <object>         class_operator_def

%type  <object>         message_send
%type  <object>         ruby_send
%type  <object>         ruby_operator_send
%type  <object>         ruby_args
%type  <object>         operator_send
%type  <object>         send_args
%type  <object>         arg_exp

%type  <object>         try_catch_block
%type  <object>         catch_blocks
%type  <object>         finally_block
%type  <object>         catch_block
%type  <object>         required_catch_blocks

%type  <object>         match_expr
%type  <object>         match_body
%type  <object>         match_clause

%%

programm:       /*empty*/
                | expression_list {
                  rb_funcall(m_Parser, rb_intern("set_script_body"), 1, $1);
                }
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

expression_list: code {
                   $$ = rb_funcall(m_Parser, rb_intern("expr_list"), 2, INT2NUM(yylineno), $1);
                }
                | expression_list code {
                   $$ = rb_funcall(m_Parser, rb_intern("expr_list"), 3, INT2NUM(yylineno), $2, $1);
                }
                | delim expression_list {
                   $$ = $2;
                }
                | expression_list delim {
                   $$ = $1;
                }
                ;

expression_block: LCURLY space expression_list space RCURLY {
                   $$ = $3;
                }
                | LCURLY space RCURLY {
                   $$ = rb_funcall(m_Parser, rb_intern("expr_list"), 1, INT2NUM(yylineno));
                }
                ;

statement:      assignment
                | return_local_statement
                | return_statement
                | require_statement
                ;

exp:            method_def
                | class_def
                | try_catch_block
                | match_expr
                | message_send
                | operator_send
                | ruby_send
                | ruby_operator_send
                | literal_value
                | any_identifier
                | SUPER { $$ = rb_funcall(m_Parser, rb_intern("super_exp"), 1, INT2NUM(yylineno)); }
                | RETRY { $$ = rb_funcall(m_Parser, rb_intern("retry_exp"), 1, INT2NUM(yylineno)); }
                | LPAREN space exp space RPAREN {
                  $$ = $3;
                }
                | exp DOT space {
                  $$ = $1;
                }
                ;

assignment:     any_identifier EQUALS space exp {
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

constant:       CONSTANT {
                  $$ = fy_terminal_node("identifier");
                }
                ;

identifier:     IDENTIFIER {
                  $$ = fy_terminal_node("identifier");
                }
                | MATCH {
                  $$ = fy_terminal_node_from("identifier", "match");
                }
                | CLASS {
                  $$ = fy_terminal_node_from("identifier", "class");
                }
                ;

any_identifier: const_identifier
                | identifier
                ;

identifier_list: any_identifier {
                  $$ = $1;
                }
                | identifier_list COMMA any_identifier {
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
                | REQUIRE any_identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("require_stmt"), 2, INT2NUM(yylineno), $2);
                }
                ;

class_def:      class_no_super
                | class_super
                ;

const_identifier: constant {
                  $$ = rb_funcall(m_Parser, rb_intern("const_identifier"), 2, INT2NUM(yylineno), $1);
                }
                | const_identifier constant {
                  $$ = rb_funcall(m_Parser, rb_intern("const_identifier"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

def:            DEF PRIVATE { $$ = rb_intern("private"); }
                | DEF PROTECTED { $$ = rb_intern("protected"); }
                | DEF { $$ = rb_intern("public"); }
                ;

class_no_super: CLASS const_identifier expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("class_def"), 4, INT2NUM(yylineno), $2, Qnil, $3);
                }
                ;

class_super:    CLASS const_identifier COLON const_identifier expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("class_def"), 4, INT2NUM(yylineno), $2, $4, $5);
                }
                ;

method_def:     method_w_args
                | method_no_args
                | class_method_w_args
                | class_method_no_args
                | operator_def
                | class_operator_def
                ;

method_arg:     identifier COLON identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("method_arg"), 3, INT2NUM(yylineno), $1, $3);
                }
                ;

method_args:    method_arg {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_ary"), 2, INT2NUM(yylineno), $1);
                }
                | method_args method_arg {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_ary"), 3, INT2NUM(yylineno), $2, $1);
                }
                | method_args method_args_default {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_ary"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

method_arg_default: identifier COLON identifier EQUALS exp {
                  $$ = rb_funcall(m_Parser, rb_intern("method_arg"), 4, INT2NUM(yylineno), $1, $3, $5);
                }
                ;

method_args_default: method_arg_default {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_ary"), 2, INT2NUM(yylineno), $1);
                }
                | method_args_default COMMA space method_arg_default {
                  $$ = rb_funcall(m_Parser, rb_intern("expr_ary"), 3, INT2NUM(yylineno), $4, $1);
                }
                ;

method_w_args:  def method_args expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("method_def_expand"), 4, INT2NUM(yylineno), $2, $3, $1);
                }
                ;


method_no_args: def identifier expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("method_def_no_args"), 4, INT2NUM(yylineno), $2, $3, $1);
                }
                ;


class_method_w_args: def any_identifier method_args expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_method_def_expand"), 5, INT2NUM(yylineno), $2, $3, $4, $1);
                }
                ;

class_method_no_args: def any_identifier identifier expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_method_def_no_args"), 5, INT2NUM(yylineno), $2, $3, $4, $1);
                }
                ;

operator_def:   def operator identifier expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("operator_def"), 5, INT2NUM(yylineno), $2, $3, $4, $1);
                }
                | def LBRACKET RBRACKET identifier expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("operator_def"), 5,
                                  INT2NUM(yylineno), fy_terminal_node_from("identifier", "[]"), $4, $5, $1);
                }
                ;

class_operator_def: def any_identifier operator identifier expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_operator_def"), 6, INT2NUM(yylineno), $2, $3, $4, $5, $1);
                }
                | def any_identifier LBRACKET RBRACKET identifier expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("sin_operator_def"), 6,
                                  INT2NUM(yylineno), $2, fy_terminal_node_from("identifier", "[]"), $5, $6, $1);
                }
                ;

message_send:   exp identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("msg_send_basic"), 3, INT2NUM(yylineno), $1, $2);
                }
                | exp send_args {
                  $$ = rb_funcall(m_Parser, rb_intern("msg_send_args"), 3, INT2NUM(yylineno), $1, $2);
                }
                | send_args {
                  $$ = rb_funcall(m_Parser, rb_intern("msg_send_args"), 3, INT2NUM(yylineno), Qnil, $1);
                }
                ;

ruby_send:      exp identifier ruby_args {
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

operator_send:  exp operator arg_exp {
                  $$ = rb_funcall(m_Parser, rb_intern("oper_send_basic"), 4, INT2NUM(yylineno), $1, $2, $3);
                }
                | exp operator DOT space arg_exp {
                  $$ = rb_funcall(m_Parser, rb_intern("oper_send_basic"), 4, INT2NUM(yylineno), $1, $2, $5);
                }
                | exp LBRACKET exp RBRACKET {
                  $$ = rb_funcall(m_Parser, rb_intern("oper_send_basic"), 4,
                                  INT2NUM(yylineno), $1, fy_terminal_node_from("identifier", "[]"), $3);
                }
                ;

ruby_operator_send: exp operator ruby_args {
                  $$ = rb_funcall(m_Parser, rb_intern("msg_send_ruby"), 4, INT2NUM(yylineno), $1, $2, $3);
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

arg_exp:        any_identifier {
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

try_catch_block: TRY expression_block catch_blocks finally_block {
                  $$ = rb_funcall(m_Parser, rb_intern("try_catch_finally"), 4, INT2NUM(yylineno), $2, $3, $4);
                }
                | TRY expression_block required_catch_blocks {
                  $$ = rb_funcall(m_Parser, rb_intern("try_catch_finally"), 3, INT2NUM(yylineno), $2, $3);
                }
                ;

catch_block:    CATCH expression_block  {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handler"), 2, INT2NUM(yylineno), $2);
                }
                | CATCH exp expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handler"), 3, INT2NUM(yylineno), $3, $2);
                }
                | CATCH exp ARROW identifier expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handler"), 4, INT2NUM(yylineno), $5, $2, $4);
                }
                ;

required_catch_blocks: catch_block {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handlers"), 2, INT2NUM(yylineno), $1);
                }
                | required_catch_blocks catch_block {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handlers"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

catch_blocks:   catch_block {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handlers"), 2, INT2NUM(yylineno), $1);
                }
                | catch_blocks catch_block {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handlers"), 3, INT2NUM(yylineno), $2, $1);
                }
                | /* empty */ {
                  $$ = rb_funcall(m_Parser, rb_intern("catch_handlers"), 1, INT2NUM(yylineno));
                }
                ;

finally_block:  FINALLY expression_block {
                  $$ = $2;
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
                | MULTI_STRING_LITERAL {
                  $$ = fy_terminal_node("multiline_string_literal");
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

hex_literal:    HEX_LITERAL {
                  $$ = rb_funcall(m_Parser, rb_intern("integer_literal"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(16));
                }
                ;

oct_literal:    OCT_LITERAL {
                  $$ = rb_funcall(m_Parser, rb_intern("integer_literal"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(8));
                }
                ;

bin_literal:    BIN_LITERAL {
                  $$ = rb_funcall(m_Parser, rb_intern("integer_literal"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(2));
                }
                ;

literal_value:  integer_literal
                | hex_literal
                | oct_literal
                | bin_literal
                | double_literal
                | string_literal
                | symbol_literal
                | hash_literal
                | array_literal
                | regex_literal
                | block_literal
                | tuple_literal
                | range_literal
                ;

array_literal:  empty_array {
                  $$ = $1;
                }
                | LBRACKET space exp_comma_list space RBRACKET {
                  $$ = rb_funcall(m_Parser, rb_intern("array_literal"), 2, INT2NUM(yylineno), $3);
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
                  $$ = rb_funcall(m_Parser, rb_intern("hash_literal"), 1, INT2NUM(yylineno));
                }
                ;

block_literal:  expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("block_literal"), 3, INT2NUM(yylineno), Qnil, $1);
                }
                | STAB block_args STAB space expression_block {
                  $$ = rb_funcall(m_Parser, rb_intern("block_literal"), 3, INT2NUM(yylineno), $2, $5);
                }
                ;

tuple_literal:  LPAREN space exp_comma_list space RPAREN {
                  $$ = rb_funcall(m_Parser, rb_intern("tuple_literal"), 2, INT2NUM(yylineno), $3);
                }
                ;

range_literal:  LPAREN space exp DOT DOT exp space RPAREN {
                  $$ = rb_funcall(m_Parser, rb_intern("range_literal"), 3, INT2NUM(yylineno), $3, $6);
                }
                ;

block_args:     block_args_with_comma
                | block_args_without_comma
                ;

block_args_without_comma: identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("block_args"), 2, INT2NUM(yylineno), $1);
                }
                | block_args_without_comma identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("block_args"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

block_args_with_comma: identifier {
                  $$ = rb_funcall(m_Parser, rb_intern("block_args"), 2, INT2NUM(yylineno), $1);
                }
                | block_args_with_comma COMMA identifier {
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

match_expr:     MATCH exp THIN_ARROW LCURLY space match_body space RCURLY {
                  $$ = rb_funcall(m_Parser, rb_intern("match_expr"), 3, INT2NUM(yylineno), $2, $6);
                }
                ;

match_body:     match_clause {
                  $$ = rb_funcall(m_Parser, rb_intern("match_body"), 2, INT2NUM(yylineno), $1);
                }
                | match_body match_clause {
                  $$ = rb_funcall(m_Parser, rb_intern("match_body"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

match_clause:   CASE exp THIN_ARROW expression_list {
                  $$ = rb_funcall(m_Parser, rb_intern("match_clause"), 3, INT2NUM(yylineno), $2, $4);
                }
                | CASE exp THIN_ARROW STAB identifier STAB expression_list {
                  $$ = rb_funcall(m_Parser, rb_intern("match_clause"), 4, INT2NUM(yylineno), $2, $7, $5);
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

