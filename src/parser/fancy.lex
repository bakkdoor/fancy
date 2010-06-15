%{
#include "includes.h"
#include "tok.h"
int yyerror(char *s);
%}

%option yylineno

digit		[0-9]
letter          [A-Za-z]
special         [-+?!_=*/^><%]
int_lit 	-?{digit}+
double_lit      {int_lit}\.{digit}+
string_lit      \"[^\"\n]*\"
doc_string      \"\"[^\"]*\"\"
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
return          "return:"
require         "require:"
try             "try"
catch           "catch"
finally         "finally"
super           "super"
private         "private"
protected       "protected"
native_only     "NATIVE"
identifier      @?@?({letter}|{digit}|{special})+
symbol_lit      :{identifier}
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
{int_lit}	{ yylval.object = Number::from_int(atoi(yytext)); return INTEGER_LITERAL; }
{double_lit}    { yylval.object = Number::from_double(atof(yytext)); return DOUBLE_LITERAL; }
{string_lit}	{ 
                  string str(yytext);
                  yylval.object = FancyString::from_value(str.substr(1, str.length() - 2));
                  return STRING_LITERAL;
                }
{doc_string}	{
                  string str(yytext);
                  yylval.object = FancyString::from_value(str.substr(2, str.length() - 4));
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
{special}+      {
                  string str(yytext);
                  yylval.expression = fancy::parser::nodes::Identifier::from_string(str);
                  return OPERATOR;
                }
{return}        { return RETURN; }
{require}       { return REQUIRE; }
{try}           { return TRY; }
{catch}         { return CATCH; }
{finally}       { return FINALLY; }
{super}         { return SUPER; }
{private}       { return PRIVATE; }
{protected}     { return PROTECTED; }
{native_only}   { return NATIVE_ONLY; }
{identifier}    { 
                  string str(yytext);
                  yylval.expression = fancy::parser::nodes::Identifier::from_string(str);
                  return IDENTIFIER;
                }
{symbol_lit}    { 
                  string str(yytext);
                  yylval.object = Symbol::from_string(str);
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
[\n]		{ yylineno++; }

.		{ fprintf(stderr, "SCANNER %d", yyerror("")); exit(1);	}

