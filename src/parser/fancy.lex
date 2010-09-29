%{
#include "../../vendor/gc/include/gc.h"
#include "../../vendor/gc/include/gc_cpp.h"
#include "../../vendor/gc/include/gc_allocator.h"

#include "includes.h"
#include "tok.h"
#include "../utils.h"
int yyerror(char *s);
string underscore = "_";
string empty = "";
%}

%option yylineno

digit		[0-9]
letter          [A-Za-z]
special         [-+?!_=*/^><%&]
operator        ({special}+|"||"{special}*)
int_lit 	-?({digit}|_)+
double_lit      {int_lit}\.{digit}+
string_lit      \"[^\"\n]*\"
doc_string      \"\"\"[^\"]*\"\"\"
lparen          \(
rparen          \)
lcurly          "{"
rcurly          "}"
lbracket        "["
rbracket        "]"
lhash           "<["
rhash           "]>"
stab            "|"
arrow           "=>"
delimiter       [ \n\r\t\(\)]
return_local    "return_local"
return          "return"
require         "require:"
try             "try"
catch           "catch"
finally         "finally"
retry           "retry"
super           "super"
private         "private"
protected       "protected"
rb_args_prefix  "~"
self            "self"
identifier      @?@?({letter}|{digit}|{special})+
nested_identifier (({letter}({letter}|{digit}|{special})+)::)+({letter}({letter}|{digit}|{special})+)
symbol_lit      \'({identifier}|{operator}|:|"[]")+
regexp_lit      "r{".*"}"
comma           ,
semi            ;
equals          =
colon           :
def_class       "def"[ \t]+"class"
def             "def"
dot             "."
dollar          "$"
comment         #[^\n]*

%%

{def_class}     { return DEFCLASS; }
{def}           { return DEF; }
{int_lit}	{
                  string str(yytext);
                  int val = atoi(string_replace(str, underscore, empty).c_str());
                  yylval.object = Number::from_int(val);
                  return INTEGER_LITERAL;
                }
{double_lit}    {
                  string str(yytext);
                  double val = atof(string_replace(str, underscore, empty).c_str());
                  yylval.object = Number::from_double(val);
                  return DOUBLE_LITERAL;
                }
{string_lit}	{
                  string str(yytext);
                  yylval.object = FancyString::from_value(str.substr(1, str.length() - 2));
                  return STRING_LITERAL;
                }
{doc_string}	{
                  string str(yytext);
                  yylval.object = FancyString::from_value(str.substr(3, str.length() - 6));
                  return STRING_LITERAL;
                }
{lparen}        { return LPAREN; }
{rparen}        { return RPAREN; }
{lcurly}        { return LCURLY; }
{rcurly}        { return RCURLY; }
{lbracket}      { return LBRACKET; }
{rbracket}      { return RBRACKET; }
{lhash}         { return LHASH; }
{rhash}         { return RHASH; }
{stab}          { return STAB; }
{arrow}         { return ARROW; }
{equals}        { return EQUALS; }
{operator}      {
                  string str(yytext);
                  yylval.expression = fancy::parser::nodes::Identifier::from_string(str);
                  return OPERATOR;
                }
{return_local}  { return RETURN_LOCAL; }
{return}        { return RETURN; }
{require}       { return REQUIRE; }
{try}           { return TRY; }
{catch}         { return CATCH; }
{finally}       { return FINALLY; }
{retry}         { return RETRY; }
{super}         { return SUPER; }
{private}       { return PRIVATE; }
{protected}     { return PROTECTED; }
{rb_args_prefix} { return RB_ARGS_PREFIX; }
{self}          { yylval.expression = fancy::parser::nodes::Self::node(); return IDENTIFIER; }
{identifier}    {
                  string str(yytext);
                  yylval.expression = fancy::parser::nodes::Identifier::from_string(str);
                  return IDENTIFIER;
                }
{nested_identifier} {
                  string str(yytext);
                  Identifier* ident = fancy::parser::nodes::Identifier::from_string(str);
                  ident->set_nested(true);
                  yylval.expression = ident;
                  return IDENTIFIER;
                }
{symbol_lit}    {
                  string str(yytext + 1);
                  yylval.object = Symbol::from_string("'" + str);
                  return SYMBOL_LITERAL;
                }
{regexp_lit}    {
                  string str(yytext);
                  yylval.object = new Regexp(str.substr(2, str.length() - 3));
                  return REGEXP_LITERAL;
                }
{comma}         { return COMMA; }
{semi}          { return SEMI; }
{colon}         { return COLON; }
{dot}           { return DOT; }
{dollar}        { return DOLLAR; }

{comment}       {}

[ \t]*		{}
[\n]		{ return NL; }

.		{ fprintf(stderr, "SCANNER %d", yyerror("")); exit(1);	}

