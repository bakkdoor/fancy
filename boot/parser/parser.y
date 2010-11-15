%{
#include "ruby.h"

int yyerror(VALUE, char *s);
int yylex(VALUE);

VALUE fy_terminal_node(VALUE, char *);
VALUE fy_terminal_node_from(VALUE, char *, char*);

extern int yylineno;
extern char *yytext;

%}

%lex-param   { VALUE self }
%parse-param { VALUE self }

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
%token                  SELECTOR
%token                  RUBY_SEND_OPEN
%token                  RUBY_OPER_OPEN
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
%type  <object>         selector


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
%type  <object>         ruby_send_open
%type  <object>         ruby_oper_open
%type  <object>         ruby_send
%type  <object>         ruby_oper_send
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
                  rb_funcall(self, rb_intern("body:"), 1, $1);
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
                   $$ = rb_funcall(self, rb_intern("ast:exp_list:"), 2, INT2NUM(yylineno), $1);
                }
                | expression_list code {
                   $$ = rb_funcall(self, rb_intern("ast:exp_list:into:"), 3, INT2NUM(yylineno), $2, $1);
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
                   $$ = rb_funcall(self, rb_intern("ast:exp_list:"), 2, INT2NUM(yylineno), Qnil);
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
                | ruby_oper_send
                | literal_value
                | any_identifier
                | SUPER { $$ = rb_funcall(self, rb_intern("ast:super_exp:"), 2, INT2NUM(yylineno), Qnil); }
                | RETRY { $$ = rb_funcall(self, rb_intern("ast:retry_exp:"), 2, INT2NUM(yylineno), Qnil); }
                | LPAREN space exp space RPAREN {
                  $$ = $3;
                }
                | exp DOT space {
                  $$ = $1;
                }
                ;

assignment:     any_identifier EQUALS space exp {
                  $$ = rb_funcall(self, rb_intern("ast:assign:to:"), 3, INT2NUM(yylineno), $4, $1);
                }
                | multiple_assignment
                ;

multiple_assignment: identifier_list EQUALS exp_comma_list {
                  $$ = rb_funcall(self, rb_intern("ast:assign:to:many:"), 4, INT2NUM(yylineno), $3, $1, Qtrue);
                }
                ;

operator:       OPERATOR {
                  $$ = fy_terminal_node(self, "ast:identifier:");
                }
                ;

constant:       CONSTANT {
                  $$ = fy_terminal_node(self, "ast:identifier:");
                }
                ;

selector:       SELECTOR {
                  $$ = fy_terminal_node(self, "ast:identifier:");
                };

identifier:     IDENTIFIER {
                  $$ = fy_terminal_node(self, "ast:identifier:");
                }
                | MATCH {
                  $$ = fy_terminal_node_from(self, "ast:identifier:", "match");
                }
                | CLASS {
                  $$ = fy_terminal_node_from(self, "ast:identifier:", "class");
                }
                ;

any_identifier: const_identifier
                | identifier
                ;

identifier_list: any_identifier {
                  $$ = $1;
                }
                | identifier_list COMMA any_identifier {
                  $$ = rb_funcall(self, rb_intern("identifier_list"), 3, INT2NUM(yylineno), $1, $3);
                }
                ;

return_local_statement: RETURN_LOCAL exp {
                  $$ = rb_funcall(self, rb_intern("return_local"), 2, INT2NUM(yylineno), $2);
                }
                | RETURN_LOCAL {
                  $$ = rb_funcall(self, rb_intern("return_local"), 1, INT2NUM(yylineno));
                }
                ;

return_statement: RETURN exp {
                  $$ = rb_funcall(self, rb_intern("return_stmt"), 2, INT2NUM(yylineno), $2);
                }
                | RETURN {
                  $$ = rb_funcall(self, rb_intern("return_stmt"), 1, INT2NUM(yylineno));
                }
                ;

require_statement: REQUIRE string_literal {
                  $$ = rb_funcall(self, rb_intern("ast:require_:"), 2, INT2NUM(yylineno), $2);
                }
                | REQUIRE any_identifier {
                  $$ = rb_funcall(self, rb_intern("ast:require_:"), 2, INT2NUM(yylineno), $2);
                }
                ;

class_def:      class_no_super
                | class_super
                ;

const_identifier: constant {
                  $$ = rb_funcall(self, rb_intern("ast:identity:"), 2, INT2NUM(yylineno), $1);
                }
                | const_identifier constant {
                  $$ = rb_funcall(self, rb_intern("ast:constant:parent:"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

def:            DEF PRIVATE { $$ = rb_intern("private"); }
                | DEF PROTECTED { $$ = rb_intern("protected"); }
                | DEF { $$ = rb_intern("public"); }
                ;

class_no_super: CLASS const_identifier expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:class:parent:body:"), 4, INT2NUM(yylineno), $2, Qnil, $3);
                }
                ;

class_super:    CLASS const_identifier COLON const_identifier expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:class:parent:body:"), 4, INT2NUM(yylineno), $2, $4, $5);
                }
                ;

method_def:     method_w_args
                | method_no_args
                | class_method_w_args
                | class_method_no_args
                | operator_def
                | class_operator_def
                ;

method_arg:     selector identifier {
                  $$ = rb_funcall(self, rb_intern("ast:param:var:"), 3, INT2NUM(yylineno), $1, $2);
                }
                ;

method_args:    method_arg {
                  $$ = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), $1);
                }
                | method_args method_arg {
                  $$ = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), $2, $1);
                }
                | method_args method_args_default {
                  $$ = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

method_arg_default: selector identifier LPAREN space exp space RPAREN {
                  $$ = rb_funcall(self, rb_intern("ast:param:var:default:"), 4, INT2NUM(yylineno), $1, $2, $5);
                }
                ;

method_args_default: method_arg_default {
                  $$ = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), $1);
                }
                | method_args_default space method_arg_default {
                  $$ = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), $3, $1);
                }
                ;

method_w_args:  def method_args expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:method:expand:access:"), 4, INT2NUM(yylineno), $2, $3, $1);
                }
                ;


method_no_args: def identifier expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:method:body:access:"), 4, INT2NUM(yylineno), $2, $3, $1);
                }
                ;


class_method_w_args: def any_identifier method_args expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:method:expand:access:owner:"), 5, INT2NUM(yylineno), $3, $4, $1, $2);
                }
                ;

class_method_no_args: def any_identifier identifier expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:method:body:access:owner:"), 5, INT2NUM(yylineno), $3, $4, $1, $2);
                }
                ;

operator_def:   def operator identifier expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:oper:arg:body:access:"), 5, INT2NUM(yylineno), $2, $3, $4, $1);
                }
                | def LBRACKET RBRACKET identifier expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:oper:arg:body:access:"), 5,
                                  INT2NUM(yylineno), fy_terminal_node_from(self, "ast:identifier:", "[]"), $4, $5, $1);
                }
                ;

class_operator_def: def any_identifier operator identifier expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:oper:arg:body:access:owner:"), 6, INT2NUM(yylineno), $3, $4, $5, $1, $2);
                }
                | def any_identifier LBRACKET RBRACKET identifier expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:oper:arg:body:access:owner:"), 6,
                                  INT2NUM(yylineno), fy_terminal_node_from(self, "ast:identifier:", "[]"), $5, $6, $1, $2);
                }
                ;

message_send:   exp identifier {
                  $$ = rb_funcall(self, rb_intern("ast:send:to:"), 3, INT2NUM(yylineno), $2, $1);
                }
                | exp send_args {
                  $$ = rb_funcall(self, rb_intern("ast:send:to:"), 3, INT2NUM(yylineno), $2, $1);
                }
                | send_args {
                  $$ = rb_funcall(self, rb_intern("ast:send:"), 2, INT2NUM(yylineno), $1);
                }
                ;

/* ruby_send_open is just an identifier immediatly followed by a left-paren
   NO SPACE ALLOWED between the identifier and the left-paren. that's why we
   need a parse rule.
*/
ruby_send_open: RUBY_SEND_OPEN {
                  // remove the trailing left paren and create an identifier.
                  $$ = fy_terminal_node(self, "ast:ruby_send:");
                };
ruby_oper_open: RUBY_OPER_OPEN {
                  // remove the trailing left paren and create an identifier.
                  $$ = fy_terminal_node(self, "ast:ruby_send:");
                };

ruby_send:      exp ruby_send_open ruby_args {
                  $$ = rb_funcall(self, rb_intern("ast:send:to:ruby:"), 4, INT2NUM(yylineno), $2, $1, $3);
                }
                | ruby_send_open ruby_args {
                  $$ = rb_funcall(self, rb_intern("ast:send:to:ruby:"), 4, INT2NUM(yylineno), $1, Qnil, $2);
                }
                ;

/*
   The closing part of ruby_send_open.
   We explicitly require parens for ALL ruby sends now, so there will always be
   a closing paren.
*/
ruby_args:      RPAREN block_literal  {
                  $$ = rb_funcall(self, rb_intern("ast:ruby_args:block:"), 3, INT2NUM(yylineno), Qnil, $2);
                }
                | exp_comma_list RPAREN block_literal {
                  $$ = rb_funcall(self, rb_intern("ast:ruby_args:block:"), 3, INT2NUM(yylineno), $1, $3);
                }
                | RPAREN {
                  $$ = rb_funcall(self, rb_intern("ast:ruby_args:"), 2, INT2NUM(yylineno), Qnil);
                }
                | exp_comma_list RPAREN {
                  $$ = rb_funcall(self, rb_intern("ast:ruby_args:"), 2, INT2NUM(yylineno), $1);
                }
                ;

operator_send:  exp operator arg_exp {
                  $$ = rb_funcall(self, rb_intern("ast:oper:arg:to:"), 4, INT2NUM(yylineno), $2, $3, $1);
                }
                | exp operator DOT space arg_exp {
                  $$ = rb_funcall(self, rb_intern("ast:oper:arg:to:"), 4, INT2NUM(yylineno), $2, $5, $1);
                }
                | exp LBRACKET exp RBRACKET {
                  $$ = rb_funcall(self, rb_intern("ast:oper:arg:to:"), 4,
                                  INT2NUM(yylineno), fy_terminal_node_from(self, "ast:identifier:", "[]"), $3, $1);
                }
                ;

ruby_oper_send: exp ruby_oper_open ruby_args {
                  $$ = rb_funcall(self, rb_intern("ast:send:to:ruby:"), 4, INT2NUM(yylineno), $2, $1, $3);
                }
                ;


send_args:      selector arg_exp {
                  $$ = rb_funcall(self, rb_intern("ast:send:arg:"), 3, INT2NUM(yylineno), $1, $2);
                }
                | selector space arg_exp {
                  $$ = rb_funcall(self, rb_intern("ast:send:arg:"), 3, INT2NUM(yylineno), $1, $3);
                }
                | send_args selector arg_exp {
                  $$ = rb_funcall(self, rb_intern("ast:send:arg:ary:"), 4, INT2NUM(yylineno), $2, $3, $1);
                }
                | send_args selector space arg_exp {
                  $$ = rb_funcall(self, rb_intern("ast:send:arg:ary:"), 4, INT2NUM(yylineno), $2, $4, $1);
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
                  $$ = rb_funcall(self, rb_intern("ast:try_block:ex_handlers:finally_block:"), 4, INT2NUM(yylineno), $2, $3, $4);
                }
                | TRY expression_block required_catch_blocks {
                  $$ = rb_funcall(self, rb_intern("ast:try_block:ex_handlers:"), 3, INT2NUM(yylineno), $2, $3);
                }
                ;

catch_block:    CATCH expression_block  {
                  $$ = rb_funcall(self, rb_intern("ast:ex_handler:"), 2, INT2NUM(yylineno), $2);
                }
                | CATCH exp expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:ex_handler:cond:"), 3, INT2NUM(yylineno), $3, $2);
                }
                | CATCH exp ARROW identifier expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:ex_handler:cond:var:"), 4, INT2NUM(yylineno), $5, $2, $4);
                }
                ;

required_catch_blocks: catch_block {
                  $$ = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), $1);
                }
                | required_catch_blocks catch_block {
                  $$ = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

catch_blocks:   catch_block {
                  $$ = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), $1);
                }
                | catch_blocks catch_block {
                  $$ = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), $2, $1);
                }
                | /* empty */ {
                  $$ = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), Qnil);
                }
                ;

finally_block:  FINALLY expression_block {
                  $$ = $2;
                }
                ;

integer_literal: INTEGER_LITERAL {
                  $$ = fy_terminal_node(self, "ast:fixnum:");
                }
                ;
double_literal: DOUBLE_LITERAL {
                  $$ = fy_terminal_node(self, "ast:number:");
                }
                ;
string_literal: STRING_LITERAL {
                  $$ = fy_terminal_node(self, "ast:string:");
                }
                | MULTI_STRING_LITERAL {
                  $$ = fy_terminal_node(self, "ast:string:");
                }
                ;
symbol_literal: SYMBOL_LITERAL {
                  $$ = fy_terminal_node(self, "ast:symbol:");
                }
                ;
regex_literal: REGEX_LITERAL {
                  $$ = fy_terminal_node(self, "regex");
                }
                ;

hex_literal:    HEX_LITERAL {
                  $$ = rb_funcall(self, rb_intern("ast:fixnum:base:"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(16));
                }
                ;

oct_literal:    OCT_LITERAL {
                  $$ = rb_funcall(self, rb_intern("ast:fixnum:base:"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(8));
                }
                ;

bin_literal:    BIN_LITERAL {
                  $$ = rb_funcall(self, rb_intern("ast:fixnum:base:"), 3,
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
                  $$ = rb_funcall(self, rb_intern("ast:array:"), 2, INT2NUM(yylineno), $3);
                }
                ;

exp_comma_list: exp {
                  $$ = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), $1);
                }
                | exp_comma_list COMMA space exp {
                  $$ = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), $4, $1);
                }
                | exp_comma_list COMMA {
                  $$ = $1;
                }
                ;

empty_array:    LBRACKET space RBRACKET {
                  $$ = rb_funcall(self, rb_intern("ast:array:"), 2, INT2NUM(yylineno), Qnil);
                }
                ;

hash_literal:   LHASH space key_value_list space RHASH {
                  $$ = rb_funcall(self, rb_intern("ast:hash:"), 2, INT2NUM(yylineno), $3);
                }
                | LHASH space RHASH {
                  $$ = rb_funcall(self, rb_intern("ast:hash:"), 2, INT2NUM(yylineno), Qnil);
                }
                ;

block_literal:  expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:block:"), 2, INT2NUM(yylineno), $1);
                }
                | STAB block_args STAB space expression_block {
                  $$ = rb_funcall(self, rb_intern("ast:block:args:"), 3, INT2NUM(yylineno), $5, $2);
                }
                ;

tuple_literal:  LPAREN exp_comma_list RPAREN {
                  $$ = rb_funcall(self, rb_intern("ast:tuple:"), 2, INT2NUM(yylineno), $2);
                }
                ;

range_literal:  LPAREN exp DOT DOT exp RPAREN {
                  $$ = rb_funcall(self, rb_intern("ast:range:to:"), 3, INT2NUM(yylineno), $2, $5);
                }
                ;

block_args:     block_args_with_comma
                | block_args_without_comma
                ;

block_args_without_comma: identifier {
                  $$ = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), $1);
                }
                | block_args_without_comma identifier {
                  $$ = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

block_args_with_comma: identifier {
                  $$ = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), $1);
                }
                | block_args_with_comma COMMA identifier {
                  $$ = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), $3, $1);
                }
                ;

key_value_list: exp space ARROW space exp {
                  $$ = rb_funcall(self, rb_intern("ast:key:value:into:"), 4, INT2NUM(yylineno), $1, $5, Qnil);
                }
                | key_value_list COMMA space exp space ARROW space exp {
                  $$ = rb_funcall(self, rb_intern("ast:key:value:into:"), 4, INT2NUM(yylineno), $4, $8, $1);
                }
                ;

match_expr:     MATCH exp THIN_ARROW LCURLY space match_body space RCURLY {
                  $$ = rb_funcall(self, rb_intern("ast:match_expr:body:"), 3, INT2NUM(yylineno), $2, $6);
                }
                ;

match_body:     match_clause {
                  $$ = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), $1);
                }
                | match_body match_clause {
                  $$ = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), $2, $1);
                }
                ;

match_clause:   CASE exp THIN_ARROW expression_list {
                  $$ = rb_funcall(self, rb_intern("ast:match_clause:body:"), 3, INT2NUM(yylineno), $2, $4);
                }
                | CASE exp THIN_ARROW STAB identifier STAB expression_list {
                  $$ = rb_funcall(self, rb_intern("ast:match_clause:body:arg:"), 4, INT2NUM(yylineno), $2, $7, $5);
                }
                ;

%%


VALUE fy_terminal_node(VALUE self, char* method) {
  return rb_funcall(self, rb_intern(method), 2,
                    INT2NUM(yylineno), rb_str_new2(yytext));
}

VALUE fy_terminal_node_from(VALUE self, char* method, char* text) {
  return rb_funcall(self, rb_intern(method), 2,
                    INT2NUM(yylineno), rb_str_new2(text));
}

int yyerror(VALUE self, char *s)
{
  rb_funcall(self, rb_intern("parse_error"), 2, INT2NUM(yylineno), rb_str_new2(yytext));
  return 1;
}

