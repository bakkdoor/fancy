%{
#include "includes.h"
#include "tok.h"
int yyerror(char *s);
/* int yylineno = 1; */
%}

digit		[0-9]
letter          [A-Za-z]
special         [-+?!_=*/^|><%]
int_lit 	-?{digit}+
double_lit      {int_lit}\.{digit}+
string_lit      \"[^\"\n]*\"
lparen          \(
rparen          \)
lcurly          "{"
rcurly          "}"
lbracket        "["
rbracket        "]"
arrow           "=>"
delimiter       [ \n\r\t\(\)]
identifier      @?@?({letter}|{digit}|{special})+
symbol_lit      :{identifier}
regex_lit       "/"[^\/]*"/"
comma           ,
equals          =
colon           :
class           "class"
def             "def"
inherit         "<"
dot             "."
dollar          "$"
comment         #[^\n]*

%%

{class}         { return CLASS; }
{inherit}       { return INHERIT; }
{def}           { return DEF; }
{int_lit}	{ yylval.object = Number::from_int(atoi(yytext)); return INTEGER_LITERAL; }
{double_lit}    { yylval.object = Number::from_double(atof(yytext)); return DOUBLE_LITERAL; }
{string_lit}	{ 
                  char *str = (char*)malloc(strlen(yytext) - 2); 
                  strncpy(str, yytext + 1, strlen(yytext) - 2);
                  yylval.object = String::from_value(str);
                  return STRING_LITERAL; 
                }
{lparen}        { return LPAREN; }
{rparen}        { return RPAREN; }
{lcurly}        { return LCURLY; }
{rcurly}        { return RCURLY; }
{lbracket}      { return LBRACKET; }
{rbracket}      { return RBRACKET; }
{arrow}         { return ARROW; }
{identifier}    { 
                  char *str = (char*)malloc(strlen(yytext));
                  strcpy(str, yytext);
                  yylval.object = Identifier::from_string(str);
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
{equals}        { return EQUALS; }
{colon}         { return COLON; }
{dot}           { return DOT; }
{dollar}        { return DOLLAR; }

{comment}       {}

[ \t]*		{}
[\n]		{ yylineno++; }

.		{ fprintf(stderr, "SCANNER %d", yyerror("")); exit(1);	}

