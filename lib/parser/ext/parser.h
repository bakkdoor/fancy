
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     LPAREN = 258,
     RPAREN = 259,
     LCURLY = 260,
     RCURLY = 261,
     LBRACKET = 262,
     RBRACKET = 263,
     LHASH = 264,
     RHASH = 265,
     STAB = 266,
     ARROW = 267,
     THIN_ARROW = 268,
     COMMA = 269,
     SEMI = 270,
     NL = 271,
     COLON = 272,
     RETURN_LOCAL = 273,
     RETURN = 274,
     REQUIRE = 275,
     TRY = 276,
     CATCH = 277,
     FINALLY = 278,
     RETRY = 279,
     SUPER = 280,
     PRIVATE = 281,
     PROTECTED = 282,
     CLASS = 283,
     DEF = 284,
     DOT = 285,
     DOLLAR = 286,
     EQUALS = 287,
     MATCH = 288,
     CASE = 289,
     IDENTIFIER = 290,
     SELECTOR = 291,
     RUBY_SEND_OPEN = 292,
     RUBY_OPER_OPEN = 293,
     CONSTANT = 294,
     INTEGER_LITERAL = 295,
     HEX_LITERAL = 296,
     OCT_LITERAL = 297,
     BIN_LITERAL = 298,
     DOUBLE_LITERAL = 299,
     STRING_LITERAL = 300,
     MULTI_STRING_LITERAL = 301,
     SYMBOL_LITERAL = 302,
     REGEX_LITERAL = 303,
     OPERATOR = 304
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 18 "/more/vic/hk/fancy/lib/parser/ext/parser.y"

  VALUE object;
  ID    symbol;



/* Line 1676 of yacc.c  */
#line 108 "/more/vic/hk/fancy/lib/parser/ext/parser.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


