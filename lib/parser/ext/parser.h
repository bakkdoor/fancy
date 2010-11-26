
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
     AT_LCURLY = 260,
     LCURLY = 261,
     RCURLY = 262,
     LBRACKET = 263,
     RBRACKET = 264,
     LHASH = 265,
     RHASH = 266,
     STAB = 267,
     ARROW = 268,
     THIN_ARROW = 269,
     COMMA = 270,
     SEMI = 271,
     NL = 272,
     COLON = 273,
     RETURN_LOCAL = 274,
     RETURN = 275,
     REQUIRE = 276,
     TRY = 277,
     CATCH = 278,
     FINALLY = 279,
     RETRY = 280,
     SUPER = 281,
     PRIVATE = 282,
     PROTECTED = 283,
     CLASS = 284,
     DEF = 285,
     DOT = 286,
     DOLLAR = 287,
     EQUALS = 288,
     MATCH = 289,
     CASE = 290,
     IDENTIFIER = 291,
     SELECTOR = 292,
     RUBY_SEND_OPEN = 293,
     RUBY_OPER_OPEN = 294,
     CONSTANT = 295,
     INTEGER_LITERAL = 296,
     HEX_LITERAL = 297,
     OCT_LITERAL = 298,
     BIN_LITERAL = 299,
     DOUBLE_LITERAL = 300,
     STRING_LITERAL = 301,
     MULTI_STRING_LITERAL = 302,
     SYMBOL_LITERAL = 303,
     REGEX_LITERAL = 304,
     OPERATOR = 305
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 18 "/home/bakkdoor/projekte/fancy/fancy-lang/lib/parser/ext/parser.y"

  VALUE object;
  ID    symbol;



/* Line 1676 of yacc.c  */
#line 109 "/home/bakkdoor/projekte/fancy/fancy-lang/lib/parser/ext/parser.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


