%{
#include "ruby.h"
#include "parser.h"

int yyerror(VALUE self, char *s);
%}

%option yylineno

digit		[0-9]
octdigit	[0-7]
hexdigit        [0-9a-fA-F]
bindigit        [01]
capital         [A-Z]
lower           [a-z]
letter          [A-Za-z]
special         [-+?!=*/^><%&~]
special_under   ({special}|"_")
operator        ({special}+|" | "|"||"{special_under}*)
int_lit 	[-+]?{digit}({digit}|_{digit})*
double_lit      {int_lit}\.{digit}+
hex_lit         0[xX]{hexdigit}+
bin_lit         0[bB]{bindigit}+
oct_lit         0[oO]{octdigit}+
string_lit      L?\"(\\.|[^\\"])*\"
backtick_lit    L?`(\\.|[^`])*`
multiline_string L?\"\"\"(\\.|[^\\"])*\"\"\"
lparen          \(
rparen          \)
at              @
atat            @@
at_lcurly       "@{"
lcurly          "{"
rcurly          "}"
lbracket        "["
rbracket        "]"
lhash           "<["
rhash           "]>"
stab            "|"
arrow           "=>"
thin_arrow      "->"
delimiter       [ \n\r\t\(\)]
return_local    "return_local"
return          "return"
try             "try"
catch           "catch"
finally         "finally"
retry           "retry"
super           "super"
self            "self"
match           "match"
case            "case"
identifier      @?@?({lower}|[_&*])({letter}|{digit}|{special_under})*
selector        ({letter}|[_&*])({letter}|{digit}|{special_under})*":"
constant        {capital}({letter}|{digit}|{special_under})*
nested_constant ({constant}::)+{constant}
symbol_lit      \'({identifier}|{operator}|{constant}|:|"[]"|"|"|".")+
ruby_send_open  ({constant}|{identifier}){lparen}
ruby_oper_open  {operator}{lparen}
regexp_lit      "/".*"/"
comma           ,

semi            ;
equals          =
colon           :
class           "class"
def             "def"
dot             "."
dollar          "$"
comment         #[^\n]*
escaped_newline "\\".*\n

%%

{class}         { return CLASS; }
{def}           { return DEF; }
{hex_lit}	{
                  yylval.object = rb_str_new2(yytext);
                  return HEX_LITERAL;
                }
{oct_lit}	{
                  yylval.object = rb_str_new2(yytext);
                  return OCT_LITERAL;
                }
{bin_lit}	{
                  yylval.object = rb_str_new2(yytext);
                  return BIN_LITERAL;
                }
{int_lit}	{
                  yylval.object = rb_str_new2(yytext);
                  return INTEGER_LITERAL;
                }
{double_lit}    {
                  yylval.object = rb_str_new2(yytext);
                  return DOUBLE_LITERAL;
                }
{string_lit}	{
                  yylval.object = rb_str_new2(yytext);
                  return STRING_LITERAL;
                }
{backtick_lit}	{
                  yylval.object = rb_str_new2(yytext);
                  return BACKTICK_LITERAL;
                }
{multiline_string} {
                  yylval.object = rb_str_new2(yytext);
                  return MULTI_STRING_LITERAL;
                }
{lparen}        { return LPAREN; }
{rparen}        { return RPAREN; }
{at}            { return FUTURE_SEND; }
{atat}          { return ASYNC_SEND; }
{at_lcurly}     { return AT_LCURLY; }
{lcurly}        { return LCURLY; }
{rcurly}        { return RCURLY; }
{lbracket}      { return LBRACKET; }
{rbracket}      { return RBRACKET; }
{lhash}         { return LEFTHASH; }
{rhash}         { return RIGHTHASH; }
{stab}          { return STAB; }
{arrow}         { return ARROW; }
{thin_arrow}    { return THIN_ARROW; }
{equals}        { return EQUALS; }
{operator}      {
                  yylval.object = rb_str_new2(yytext);
                  return OPERATOR;
                }
{return_local}  { return RETURN_LOCAL; }
{return}        { return RETURN; }
{try}           { return TRY; }
{catch}         { return CATCH; }
{finally}       { return FINALLY; }
{retry}         { return RETRY; }
{super}         { return SUPER; }
{self}          {
                  yylval.object = rb_str_new2(yytext);
                  return IDENTIFIER;
                }
{match}         {
                  return MATCH;
                }
{case}          {
                  return CASE;
                }
{identifier}    {
                  yylval.object = rb_str_new2(yytext);
                  return IDENTIFIER;
                }
{selector}      {
                  yylval.object = rb_str_new2(yytext);
                  return SELECTOR;
                }
{ruby_send_open} {
                  yylval.object = rb_str_new2(yytext);
                  return RUBY_SEND_OPEN;
                }
{ruby_oper_open} {
                  yylval.object = rb_str_new2(yytext);
                  return RUBY_OPER_OPEN;
                }
{constant}      {
                  yylval.object = rb_str_new2(yytext);
                  return CONSTANT;
                }
{nested_constant} {
                  yylval.object = rb_str_new2(yytext);
                  return CONSTANT;
                }
{symbol_lit}    {
                  yylval.object = rb_str_new2(yytext);
                  return SYMBOL_LITERAL;
                }
{regexp_lit}    {
                  yylval.object = rb_str_new2(yytext);
                  return REGEX_LITERAL;
                }
{comma}         { return COMMA; }
{semi}          { return SEMI; }
{colon}         { return COLON; }
{dot}           { return DOT; }
{dollar}        { return DOLLAR; }

{comment}       {}

[ \t]*		{}
{escaped_newline} {}
[\n]		{ return NL; }

.		{
  fprintf(stderr, "Invalid token: %s\n", yytext);
  VALUE fancy = rb_const_get(rb_cObject, rb_intern("Fancy"));
  VALUE parser = rb_const_get(fancy, rb_intern("Parser"));
  yyerror(parser, yytext);
}

