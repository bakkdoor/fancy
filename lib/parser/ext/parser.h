/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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
/* Tokens.  */
#define LPAREN 258
#define RPAREN 259
#define AT_LCURLY 260
#define LCURLY 261
#define RCURLY 262
#define LBRACKET 263
#define RBRACKET 264
#define LHASH 265
#define RHASH 266
#define STAB 267
#define ARROW 268
#define THIN_ARROW 269
#define COMMA 270
#define SEMI 271
#define NL 272
#define COLON 273
#define RETURN_LOCAL 274
#define RETURN 275
#define REQUIRE 276
#define TRY 277
#define CATCH 278
#define FINALLY 279
#define RETRY 280
#define SUPER 281
#define PRIVATE 282
#define PROTECTED 283
#define CLASS 284
#define DEF 285
#define DOT 286
#define DOLLAR 287
#define EQUALS 288
#define MATCH 289
#define CASE 290
#define IDENTIFIER 291
#define SELECTOR 292
#define RUBY_SEND_OPEN 293
#define RUBY_OPER_OPEN 294
#define CONSTANT 295
#define INTEGER_LITERAL 296
#define HEX_LITERAL 297
#define OCT_LITERAL 298
#define BIN_LITERAL 299
#define DOUBLE_LITERAL 300
#define STRING_LITERAL 301
#define MULTI_STRING_LITERAL 302
#define SYMBOL_LITERAL 303
#define REGEX_LITERAL 304
#define OPERATOR 305




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 18 "/Users/backtype/projects/fancy/lib/parser/ext/parser.y"
{
  VALUE object;
  ID    symbol;
}
/* Line 1529 of yacc.c.  */
#line 154 "/Users/backtype/projects/fancy/lib/parser/ext/parser.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

