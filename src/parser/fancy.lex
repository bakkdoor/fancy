%{
#include "includes.h"
#include "tok.h"
int yyerror(char *s);
/* int yylineno = 1; */
%}

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
identifier      @?@?({letter}|{digit}|{special})+
symbol_lit      :{identifier}
regex_lit       "/"[^\/]*"/"
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
                  char *str = (char*)malloc(strlen(yytext) - 2); 
                  strncpy(str, yytext + 1, strlen(yytext) - 2);
                  yylval.object = String::from_value(str);
                  return STRING_LITERAL;
                }
{doc_string}	{ 
                  char *str = (char*)malloc(strlen(yytext) - 3); 
                  strncpy(str, yytext + 2, strlen(yytext) - 4);
                  yylval.object = String::from_value(str);
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
                  char *str = (char*)malloc(strlen(yytext));
                  strcpy(str, yytext);
                  yylval.expression = Identifier::from_string(str);
                  return OPERATOR;
                }
{return}        { return RETURN; }
{require}       { return REQUIRE; }
{try}           { return TRY; }
{catch}         { return CATCH; }
{identifier}    { 
                  char *str = (char*)malloc(strlen(yytext));
                  strcpy(str, yytext);
                  yylval.expression = Identifier::from_string(str);
                  return IDENTIFIER;
                }
{symbol_lit}    { 
                  char *str = (char*)malloc(strlen(yytext));
                  strcpy(str, yytext);
                  yylval.object = Symbol::from_string(str);
                  return SYMBOL_LITERAL;
                }
{regex_lit}    { 
                  char *str = (char*)malloc(strlen(yytext) - 2);
                  strncpy(str, yytext + 1, strlen(yytext) - 2);
                  yylval.object = new Regex(str);
                  return REGEX_LITERAL;
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

