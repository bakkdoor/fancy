
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 1 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"

#include "ruby.h"

int yyerror(VALUE, char *s);
int yylex(VALUE);

VALUE fy_terminal_node(VALUE, char *);
VALUE fy_terminal_node_from(VALUE, char *, char*);

extern int yylineno;
extern char *yytext;



/* Line 189 of yacc.c  */
#line 88 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


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

/* Line 214 of yacc.c  */
#line 18 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"

  VALUE object;
  ID    symbol;



/* Line 214 of yacc.c  */
#line 180 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 192 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  106
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1136

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  50
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  74
/* YYNRULES -- Number of rules.  */
#define YYNRULES  166
/* YYNRULES -- Number of states.  */
#define YYNSTATES  277

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   304

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     6,     8,    10,    13,    15,    18,
      19,    21,    23,    25,    27,    30,    33,    36,    42,    46,
      48,    50,    52,    54,    56,    58,    60,    62,    64,    66,
      68,    70,    72,    74,    76,    78,    84,    88,    93,    95,
      99,   101,   103,   105,   107,   109,   111,   113,   115,   117,
     121,   124,   126,   129,   131,   134,   137,   139,   141,   143,
     146,   149,   152,   154,   158,   164,   166,   168,   170,   172,
     174,   176,   179,   181,   184,   187,   195,   197,   201,   205,
     209,   214,   219,   224,   230,   236,   243,   246,   249,   251,
     253,   255,   259,   262,   265,   269,   271,   274,   278,   284,
     289,   293,   296,   300,   304,   309,   311,   315,   317,   320,
     325,   329,   332,   336,   342,   344,   347,   349,   352,   353,
     356,   358,   360,   362,   364,   366,   368,   370,   372,   374,
     376,   378,   380,   382,   384,   386,   388,   390,   392,   394,
     396,   398,   400,   402,   408,   410,   415,   418,   422,   428,
     432,   434,   440,   444,   451,   453,   455,   457,   460,   462,
     466,   472,   481,   490,   492,   495,   500
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      51,     0,    -1,    -1,    56,    -1,    53,    -1,    15,    -1,
      52,    52,    -1,    16,    -1,    53,    16,    -1,    -1,    53,
      -1,    58,    -1,    59,    -1,    55,    -1,    56,    55,    -1,
      52,    56,    -1,    56,    52,    -1,     5,    54,    56,    54,
       6,    -1,     5,    54,     6,    -1,    60,    -1,    68,    -1,
      69,    -1,    70,    -1,    76,    -1,    71,    -1,    96,    -1,
     121,    -1,    87,    -1,    92,    -1,    90,    -1,    93,    -1,
     109,    -1,    66,    -1,    25,    -1,    24,    -1,     3,    54,
      59,    54,     4,    -1,    59,    30,    54,    -1,    66,    32,
      54,    59,    -1,    61,    -1,    67,    32,   111,    -1,    49,
      -1,    39,    -1,    36,    -1,    35,    -1,    33,    -1,    28,
      -1,    72,    -1,    65,    -1,    66,    -1,    67,    14,    66,
      -1,    18,    59,    -1,    18,    -1,    19,    59,    -1,    19,
      -1,    20,   103,    -1,    20,    66,    -1,    74,    -1,    75,
      -1,    63,    -1,    72,    63,    -1,    29,    26,    -1,    29,
      27,    -1,    29,    -1,    28,    72,    57,    -1,    28,    72,
      17,    72,    57,    -1,    81,    -1,    82,    -1,    83,    -1,
      84,    -1,    85,    -1,    86,    -1,    64,    65,    -1,    77,
      -1,    78,    77,    -1,    78,    80,    -1,    64,    65,     3,
      54,    59,    54,     4,    -1,    79,    -1,    80,    54,    79,
      -1,    73,    78,    57,    -1,    73,    65,    57,    -1,    73,
      66,    78,    57,    -1,    73,    66,    65,    57,    -1,    73,
      62,    65,    57,    -1,    73,     7,     8,    65,    57,    -1,
      73,    66,    62,    65,    57,    -1,    73,    66,     7,     8,
      65,    57,    -1,    59,    65,    -1,    59,    94,    -1,    94,
      -1,    37,    -1,    38,    -1,    59,    88,    91,    -1,    88,
      91,    -1,     4,   114,    -1,   111,     4,   114,    -1,     4,
      -1,   111,     4,    -1,    59,    62,    95,    -1,    59,    62,
      30,    54,    95,    -1,    59,     7,    59,     8,    -1,    59,
      89,    91,    -1,    64,    95,    -1,    64,    54,    95,    -1,
      94,    64,    95,    -1,    94,    64,    54,    95,    -1,    66,
      -1,     3,    59,     4,    -1,   109,    -1,    31,    59,    -1,
      21,    57,    99,   100,    -1,    21,    57,    98,    -1,    22,
      57,    -1,    22,    59,    57,    -1,    22,    59,    12,    65,
      57,    -1,    97,    -1,    98,    97,    -1,    97,    -1,    99,
      97,    -1,    -1,    23,    57,    -1,    40,    -1,    44,    -1,
      45,    -1,    46,    -1,    47,    -1,    48,    -1,    41,    -1,
      42,    -1,    43,    -1,   101,    -1,   106,    -1,   107,    -1,
     108,    -1,   102,    -1,   103,    -1,   104,    -1,   113,    -1,
     110,    -1,   105,    -1,   114,    -1,   115,    -1,   116,    -1,
     112,    -1,     7,    54,   111,    54,     8,    -1,    59,    -1,
     111,    14,    54,    59,    -1,   111,    14,    -1,     7,    54,
       8,    -1,     9,    54,   120,    54,    10,    -1,     9,    54,
      10,    -1,    57,    -1,    11,   117,    11,    54,    57,    -1,
       3,   111,     4,    -1,     3,    59,    30,    30,    59,     4,
      -1,   119,    -1,   118,    -1,    65,    -1,   118,    65,    -1,
      65,    -1,   119,    14,    65,    -1,    59,    54,    12,    54,
      59,    -1,   120,    14,    54,    59,    54,    12,    54,    59,
      -1,    33,    59,    13,     5,    54,   122,    54,     6,    -1,
     123,    -1,   122,   123,    -1,    34,    59,    13,    56,    -1,
      34,    59,    13,    11,    65,    11,    56,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   158,   158,   159,   164,   165,   166,   169,   170,   173,
     174,   177,   178,   181,   184,   187,   190,   195,   198,   203,
     204,   205,   206,   209,   210,   211,   212,   213,   214,   215,
     216,   217,   218,   219,   220,   221,   224,   229,   232,   235,
     240,   245,   250,   254,   257,   260,   265,   266,   269,   272,
     277,   280,   285,   288,   293,   296,   301,   302,   305,   308,
     313,   314,   315,   318,   323,   328,   329,   330,   331,   332,
     333,   336,   341,   344,   347,   352,   357,   360,   365,   371,
     377,   382,   387,   390,   396,   399,   405,   408,   411,   420,
     424,   429,   432,   442,   445,   448,   451,   456,   459,   462,
     468,   474,   477,   480,   483,   488,   491,   494,   497,   502,
     505,   510,   513,   516,   521,   524,   529,   532,   535,   540,
     545,   549,   553,   556,   560,   564,   569,   575,   581,   587,
     588,   589,   590,   591,   592,   593,   594,   595,   596,   597,
     598,   599,   602,   605,   610,   613,   616,   621,   626,   629,
     634,   637,   642,   647,   652,   653,   656,   659,   664,   667,
     672,   675,   680,   685,   688,   693,   696
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "LPAREN", "RPAREN", "LCURLY", "RCURLY",
  "LBRACKET", "RBRACKET", "LHASH", "RHASH", "STAB", "ARROW", "THIN_ARROW",
  "COMMA", "SEMI", "NL", "COLON", "RETURN_LOCAL", "RETURN", "REQUIRE",
  "TRY", "CATCH", "FINALLY", "RETRY", "SUPER", "PRIVATE", "PROTECTED",
  "CLASS", "DEF", "DOT", "DOLLAR", "EQUALS", "MATCH", "CASE", "IDENTIFIER",
  "SELECTOR", "RUBY_SEND_OPEN", "RUBY_OPER_OPEN", "CONSTANT",
  "INTEGER_LITERAL", "HEX_LITERAL", "OCT_LITERAL", "BIN_LITERAL",
  "DOUBLE_LITERAL", "STRING_LITERAL", "MULTI_STRING_LITERAL",
  "SYMBOL_LITERAL", "REGEX_LITERAL", "OPERATOR", "$accept", "programm",
  "delim", "nls", "space", "code", "expression_list", "expression_block",
  "statement", "exp", "assignment", "multiple_assignment", "operator",
  "constant", "selector", "identifier", "any_identifier",
  "identifier_list", "return_local_statement", "return_statement",
  "require_statement", "class_def", "const_identifier", "def",
  "class_no_super", "class_super", "method_def", "method_arg",
  "method_args", "method_arg_default", "method_args_default",
  "method_w_args", "method_no_args", "class_method_w_args",
  "class_method_no_args", "operator_def", "class_operator_def",
  "message_send", "ruby_send_open", "ruby_oper_open", "ruby_send",
  "ruby_args", "operator_send", "ruby_oper_send", "send_args", "arg_exp",
  "try_catch_block", "catch_block", "required_catch_blocks",
  "catch_blocks", "finally_block", "integer_literal", "double_literal",
  "string_literal", "symbol_literal", "regex_literal", "hex_literal",
  "oct_literal", "bin_literal", "literal_value", "array_literal",
  "exp_comma_list", "empty_array", "hash_literal", "block_literal",
  "tuple_literal", "range_literal", "block_args",
  "block_args_without_comma", "block_args_with_comma", "key_value_list",
  "match_expr", "match_body", "match_clause", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    50,    51,    51,    52,    52,    52,    53,    53,    54,
      54,    55,    55,    56,    56,    56,    56,    57,    57,    58,
      58,    58,    58,    59,    59,    59,    59,    59,    59,    59,
      59,    59,    59,    59,    59,    59,    59,    60,    60,    61,
      62,    63,    64,    65,    65,    65,    66,    66,    67,    67,
      68,    68,    69,    69,    70,    70,    71,    71,    72,    72,
      73,    73,    73,    74,    75,    76,    76,    76,    76,    76,
      76,    77,    78,    78,    78,    79,    80,    80,    81,    82,
      83,    84,    85,    85,    86,    86,    87,    87,    87,    88,
      89,    90,    90,    91,    91,    91,    91,    92,    92,    92,
      93,    94,    94,    94,    94,    95,    95,    95,    95,    96,
      96,    97,    97,    97,    98,    98,    99,    99,    99,   100,
     101,   102,   103,   103,   104,   105,   106,   107,   108,   109,
     109,   109,   109,   109,   109,   109,   109,   109,   109,   109,
     109,   109,   110,   110,   111,   111,   111,   112,   113,   113,
     114,   114,   115,   116,   117,   117,   118,   118,   119,   119,
     120,   120,   121,   122,   122,   123,   123
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     1,     1,     1,     2,     1,     2,     0,
       1,     1,     1,     1,     2,     2,     2,     5,     3,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     5,     3,     4,     1,     3,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     3,
       2,     1,     2,     1,     2,     2,     1,     1,     1,     2,
       2,     2,     1,     3,     5,     1,     1,     1,     1,     1,
       1,     2,     1,     2,     2,     7,     1,     3,     3,     3,
       4,     4,     4,     5,     5,     6,     2,     2,     1,     1,
       1,     3,     2,     2,     3,     1,     2,     3,     5,     4,
       3,     2,     3,     3,     4,     1,     3,     1,     2,     4,
       3,     2,     3,     5,     1,     2,     1,     2,     0,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     5,     1,     4,     2,     3,     5,     3,
       1,     5,     3,     6,     1,     1,     1,     2,     1,     3,
       5,     8,     8,     1,     2,     4,     7
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     9,     9,     9,     0,     5,     7,    51,    53,
       0,     0,    34,    33,    45,    62,    44,    43,    42,    89,
      41,   120,   126,   127,   128,   121,   122,   123,   124,   125,
       0,     0,     4,    13,     3,   150,    11,    12,    19,    38,
      58,     0,    47,    32,     0,    20,    21,    22,    24,    46,
       0,    56,    57,    23,    65,    66,    67,    68,    69,    70,
      27,     0,    29,    28,    30,    88,    25,   129,   133,   134,
     135,   138,   130,   131,   132,    31,   137,   142,   136,   139,
     140,   141,    26,    10,     0,   144,    32,     0,     0,     0,
       0,    45,    44,   156,     0,   155,   154,    50,    52,    55,
      54,   118,     0,    60,    61,     0,     1,     0,    15,     8,
      16,    14,     0,     9,    90,    40,     0,    86,     0,     0,
      87,     0,     0,     0,   105,   101,   107,     9,     0,     0,
      59,     0,     0,     0,    47,     0,    72,     0,    95,   144,
      92,     0,     0,     9,     9,   152,     9,    18,     9,   147,
       9,   149,     9,     9,     9,   157,     0,     0,   114,   110,
       0,     0,    63,     0,     6,     0,    36,     9,    97,    91,
     100,   144,   108,   102,     0,    49,    39,     0,     0,    71,
      79,     0,     0,     0,     0,    78,     0,    73,    76,     9,
      93,    96,     0,   103,     0,     0,     0,     4,     0,     0,
       0,     9,     0,     0,   159,   111,     0,   115,     0,   117,
     109,     0,     9,    99,     0,   106,    37,     0,    82,     0,
       0,    81,    80,    71,     0,    94,   104,    35,     0,   145,
      17,   143,     9,     0,   148,   151,     0,   112,   119,    64,
       0,    98,    83,     0,    84,     9,     0,    77,   153,     0,
       9,     0,     0,     9,   163,    85,     0,     0,   160,     0,
     113,     0,     0,   164,     9,     9,     0,   162,     0,     0,
       0,   165,    75,   161,   156,     0,   166
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    30,   110,    83,   166,    33,   108,    35,    36,    37,
      38,    39,   116,    40,    41,    42,    86,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    53,   136,   137,   188,
     189,    54,    55,    56,    57,    58,    59,    60,    61,   119,
      62,   140,    63,    64,    65,   125,    66,   158,   159,   160,
     210,    67,    68,    69,    70,    71,    72,    73,    74,    75,
      76,   141,    77,    78,    79,    80,    81,    94,    95,    96,
     153,    82,   253,   254
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -130
static const yytype_int16 yypact[] =
{
     648,   740,     1,     1,     1,    51,  -130,  -130,   878,   878,
     255,    25,  -130,  -130,    24,    78,   878,  -130,  -130,  -130,
    -130,  -130,  -130,  -130,  -130,  -130,  -130,  -130,  -130,  -130,
      38,   648,    67,  -130,   648,  -130,  -130,   982,  -130,  -130,
    -130,   924,  -130,     7,    10,  -130,  -130,  -130,  -130,    24,
      96,  -130,  -130,  -130,  -130,  -130,  -130,  -130,  -130,  -130,
    -130,   497,  -130,  -130,  -130,    53,  -130,  -130,  -130,  -130,
    -130,  -130,  -130,  -130,  -130,  -130,  -130,  -130,  -130,  -130,
    -130,  -130,  -130,    67,   878,  1063,  -130,    14,   602,   786,
     832,  -130,  -130,    86,   111,    51,   113,   982,   982,  -130,
    -130,   103,    20,  -130,  -130,   350,  -130,   648,   648,  -130,
      61,  -130,   878,     1,  -130,  -130,   951,  -130,   497,   497,
      53,   878,   878,   997,  -130,  -130,  -130,     1,    63,   878,
    -130,   122,    51,    51,    25,   127,  -130,    11,    50,   982,
    -130,    18,   924,   545,    -1,  -130,  1102,  -130,   648,  -130,
     104,  -130,   545,   105,     1,  -130,    51,   878,   115,   103,
     114,    24,  -130,   142,    61,  1019,  -130,     1,  -130,  -130,
    -130,    16,   295,  -130,   878,  -130,   135,    51,    25,  -130,
    -130,   143,    51,    25,    11,  -130,    51,  -130,  -130,    52,
    -130,    50,   997,  -130,   148,   878,   878,    67,   147,   150,
     155,     1,   159,    25,  -130,  -130,   152,  -130,    25,  -130,
    -130,     9,     1,  -130,   997,  -130,   982,    25,  -130,    51,
      25,  -130,  -130,   167,    53,  -130,  -130,  -130,    36,   982,
    -130,  -130,     1,   878,  -130,  -130,    51,  -130,  -130,  -130,
     138,  -130,  -130,    25,  -130,     1,    51,  -130,  -130,   878,
     545,    25,   878,    44,  -130,  -130,   878,   167,   982,   163,
    -130,  1046,   171,  -130,   545,     1,   694,  -130,   175,   878,
      51,   648,  -130,   982,    56,   648,   648
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -130,  -130,     4,     2,   223,   -33,     6,   211,  -130,   196,
    -130,  -130,   -42,   -46,   -38,    76,     0,  -130,  -130,  -130,
    -130,  -130,    -7,  -130,  -130,  -130,  -130,  -126,    48,   -40,
    -130,  -130,  -130,  -130,  -130,  -130,  -130,  -130,   299,  -130,
    -130,    21,  -130,  -130,   342,   -97,  -130,   -16,  -130,  -130,
    -130,  -130,  -130,   181,  -130,  -130,  -130,  -130,  -130,   -36,
    -130,    12,  -130,  -130,  -129,  -130,  -130,  -130,  -130,  -130,
    -130,  -130,  -130,   -60
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -159
static const yytype_int16 yytable[] =
{
      43,   111,    32,   130,    31,   126,    34,   102,   132,   190,
      99,   187,   133,    87,     2,     7,     2,     7,   145,   168,
     215,   -48,   191,   112,   128,     2,   173,   142,   146,   195,
       2,    43,   146,    32,    43,   107,    32,   161,   106,   127,
     248,   124,   129,   112,    91,   193,   144,    18,    20,    92,
     135,    17,    18,    19,   114,     2,   130,   -74,   187,    20,
       7,     5,   225,    20,    91,   115,   113,   275,     7,    92,
    -158,    17,    18,    19,   114,   111,     6,     7,   252,    91,
     126,    93,   142,   109,    92,   115,    17,   126,    43,    18,
      32,    91,    31,   182,   148,   226,    92,   133,    17,   186,
    -158,   150,    20,   131,   103,   104,   126,    43,    43,    32,
      32,   107,    32,   117,   164,   111,   124,   241,   146,   201,
       7,     7,   154,   124,    91,   157,   134,   156,   175,    92,
     177,    17,    18,    87,   181,    20,   157,   208,  -116,   169,
     170,   176,   124,   207,   209,   115,   186,   212,    43,   146,
     197,   219,   227,   230,   211,    91,   126,     2,   231,   112,
      92,   117,    17,    18,   236,   130,    32,   232,   164,   234,
     245,   155,   252,   117,   117,   265,   115,   267,   126,   272,
      91,   117,   113,   184,   247,    92,   246,    17,    18,    19,
     114,   100,   124,   263,     0,     0,     0,    85,     0,     0,
       0,   115,     0,     0,    97,    98,     0,     0,   178,   179,
       0,   183,   105,     0,   124,   117,     0,     0,     0,   117,
       0,     0,   101,     0,    84,    88,    89,    90,   117,     0,
       0,     0,   204,     0,     0,     0,     0,     0,   111,     0,
       0,   117,     0,   111,     0,     0,     0,   117,   117,     0,
       0,     0,     0,   217,     0,     0,     0,   139,   220,     0,
       0,     0,   223,     0,   123,     0,    43,     0,    32,     0,
      31,    43,   271,    32,     0,    43,    43,    32,    32,    31,
     143,   276,   117,    91,     0,   139,   152,     0,    92,     0,
      17,     0,   117,     0,    20,   243,     0,     0,     0,     0,
      26,    27,   112,     0,   117,   117,     0,     0,   165,     0,
       0,     0,   251,   162,   139,   139,     0,   171,   172,     0,
       0,     0,   257,    91,     0,   139,   117,     0,    92,     0,
      17,    18,    19,   114,   117,     0,   118,   117,     0,     0,
     117,     0,     0,     0,   115,   180,   274,     0,   185,   117,
     174,     0,     0,   206,     0,     0,     0,   112,     0,     0,
       0,     0,     0,   163,     0,   192,   194,     0,   205,   196,
     216,   198,     0,   199,     0,   200,   202,   203,    91,   120,
     113,     0,     0,    92,   118,    17,    18,    19,   114,   218,
     214,   228,   229,     0,   221,   222,   118,   118,     0,   115,
       0,     0,     0,     0,   118,     0,     0,     0,     0,     0,
       0,     0,   224,     0,   235,     0,     0,   237,     0,   238,
       0,     0,   239,     0,   233,     0,     0,   120,   242,   250,
       0,   244,     0,     0,     0,   240,     0,     0,   118,   120,
     120,     0,   118,     0,     0,   258,     0,   120,   261,     0,
       0,   118,   264,     0,   255,   249,     0,     0,     0,     0,
       0,     0,   260,     0,   118,   273,     0,     0,   256,     0,
     118,   118,     0,   259,     0,     0,   262,     0,     0,     0,
       0,   120,     0,     0,     0,   120,     0,   268,   269,     0,
       0,     0,     0,     0,   120,     0,     0,     0,     0,     0,
       1,   138,     2,     0,     3,   118,     4,   120,     5,     0,
       0,     0,     0,   120,   120,   118,     0,     0,    11,     0,
       0,    12,    13,     0,     0,    14,    15,   118,   118,     0,
      16,     0,    17,    18,    19,     0,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,     0,     0,   120,   118,
       0,     0,   112,     0,     0,     0,     0,   118,   120,     0,
     118,     7,     0,   118,     0,     0,     0,     0,     0,     0,
     120,   120,   118,    91,     0,   113,     0,     0,    92,     0,
      17,    18,    19,   114,     0,     0,     0,     0,     0,     0,
       0,     0,   120,     0,   115,     0,     0,     0,     0,     0,
     120,     0,     0,   120,     0,     1,   120,     2,   147,     3,
       0,     4,     0,     5,     0,   120,     0,     6,     7,     0,
       8,     9,    10,    11,     0,     0,    12,    13,     0,     0,
      14,    15,     0,     0,     0,    16,     0,    17,    18,    19,
       0,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,     1,     0,     2,     0,     3,     0,     4,     0,     5,
       0,     0,     0,     6,     7,     0,     8,     9,    10,    11,
       0,     0,    12,    13,     0,     0,    14,    15,     0,     0,
       0,    16,     0,    17,    18,    19,     0,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,     1,     0,     2,
       0,     3,     0,     4,     0,   270,     0,     0,     0,     6,
       7,     0,     8,     9,    10,    11,     0,     0,    12,    13,
       0,     0,    14,    15,     0,     0,     0,    16,     0,    17,
      18,    19,     0,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,     1,     0,     2,     0,     3,     0,     4,
       0,     5,     0,     0,     0,     0,     7,     0,     0,     0,
       0,    11,     0,     0,    12,    13,     0,     0,    14,    15,
       0,     0,     0,    16,     0,    17,    18,    19,     0,    20,
      21,    22,    23,    24,    25,    26,    27,    28,    29,     1,
       0,     2,     0,     3,   149,     4,     0,     5,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    11,     0,     0,
      12,    13,     0,     0,    14,    15,     0,     0,     0,    16,
       0,    17,    18,    19,     0,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,     1,     0,     2,     0,     3,
       0,     4,   151,     5,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    11,     0,     0,    12,    13,     0,     0,
      14,    15,     0,     0,     0,    16,     0,    17,    18,    19,
       0,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,     1,     0,     2,     0,     3,     0,     4,     0,     5,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    11,
       0,     0,    12,    13,     0,     0,    14,    15,     0,     0,
       0,    16,     0,    17,    18,    19,     0,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,   121,     0,     2,
       0,     3,     0,     4,     0,     5,     0,     0,     0,     0,
       7,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    91,     0,   121,   122,     2,    92,     3,    17,
       4,     0,     5,    20,    21,    22,    23,    24,    25,    26,
      27,    28,    29,     0,     0,     0,     0,     0,     0,    91,
       0,   167,   122,     0,    92,     0,    17,     0,     0,   112,
      20,    21,    22,    23,    24,    25,    26,    27,    28,    29,
     121,     0,     2,     0,     3,     0,     4,     0,     5,     0,
      91,     0,   113,     0,     0,    92,     0,    17,    18,    19,
     114,     0,     0,     0,     0,    91,   112,   213,   122,     0,
      92,   115,    17,     0,     0,     0,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,     0,    91,     0,   113,
       0,     0,    92,   112,    17,    18,    19,   114,     0,   266,
       0,     0,     0,     0,     0,     0,     0,     0,   115,     0,
     112,     0,     0,     0,    91,     0,   113,     0,     0,    92,
       0,    17,    18,    19,   114,     0,     0,     0,     0,     0,
       0,    91,     0,   144,     0,   115,    92,     0,    17,    18,
      19,   114,  -146,     0,     0,     0,  -146,     0,  -146,     0,
    -146,     0,   115,     0,     0,     0,  -146,  -146,     7,     0,
    -146,  -146,  -146,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,  -146
};

static const yytype_int16 yycheck[] =
{
       0,    34,     0,    49,     0,    41,     0,    14,    50,   138,
      10,   137,    50,     1,     5,    16,     5,    16,     4,   116,
       4,    14,     4,     7,    14,     5,   123,    65,    14,    30,
       5,    31,    14,    31,    34,    31,    34,    17,     0,    32,
       4,    41,    32,     7,    28,   142,    30,    36,    39,    33,
      50,    35,    36,    37,    38,     5,   102,     5,   184,    39,
      16,    11,   191,    39,    28,    49,    30,    11,    16,    33,
      14,    35,    36,    37,    38,   108,    15,    16,    34,    28,
     116,     5,   120,    16,    33,    49,    35,   123,    88,    36,
      88,    28,    88,   135,    88,   192,    33,   135,    35,   137,
      14,    89,    39,     7,    26,    27,   142,   107,   108,   107,
     108,   107,   110,    37,   110,   148,   116,   214,    14,    14,
      16,    16,    11,   123,    28,    22,    50,    14,   128,    33,
       8,    35,    36,   121,     7,    39,    22,    23,    23,   118,
     119,   129,   142,   159,   160,    49,   184,     5,   148,    14,
     148,     8,     4,     6,   161,    28,   192,     5,     8,     7,
      33,    85,    35,    36,    12,   211,   164,    12,   164,    10,
       3,    95,    34,    97,    98,    12,    49,     6,   214,     4,
      28,   105,    30,   135,   224,    33,   224,    35,    36,    37,
      38,    10,   192,   253,    -1,    -1,    -1,     1,    -1,    -1,
      -1,    49,    -1,    -1,     8,     9,    -1,    -1,   132,   133,
      -1,   135,    16,    -1,   214,   139,    -1,    -1,    -1,   143,
      -1,    -1,    11,    -1,     1,     2,     3,     4,   152,    -1,
      -1,    -1,   156,    -1,    -1,    -1,    -1,    -1,   271,    -1,
      -1,   165,    -1,   276,    -1,    -1,    -1,   171,   172,    -1,
      -1,    -1,    -1,   177,    -1,    -1,    -1,    61,   182,    -1,
      -1,    -1,   186,    -1,    41,    -1,   266,    -1,   266,    -1,
     266,   271,   266,   271,    -1,   275,   276,   275,   276,   275,
      84,   275,   206,    28,    -1,    89,    90,    -1,    33,    -1,
      35,    -1,   216,    -1,    39,   219,    -1,    -1,    -1,    -1,
      45,    46,     7,    -1,   228,   229,    -1,    -1,   112,    -1,
      -1,    -1,   236,   102,   118,   119,    -1,   121,   122,    -1,
      -1,    -1,   246,    28,    -1,   129,   250,    -1,    33,    -1,
      35,    36,    37,    38,   258,    -1,    37,   261,    -1,    -1,
     264,    -1,    -1,    -1,    49,   134,   270,    -1,   137,   273,
     127,    -1,    -1,   157,    -1,    -1,    -1,     7,    -1,    -1,
      -1,    -1,    -1,    13,    -1,   142,   143,    -1,   157,   146,
     174,   148,    -1,   150,    -1,   152,   153,   154,    28,    37,
      30,    -1,    -1,    33,    85,    35,    36,    37,    38,   178,
     167,   195,   196,    -1,   183,   184,    97,    98,    -1,    49,
      -1,    -1,    -1,    -1,   105,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   189,    -1,   203,    -1,    -1,   206,    -1,   208,
      -1,    -1,   211,    -1,   201,    -1,    -1,    85,   217,   233,
      -1,   220,    -1,    -1,    -1,   212,    -1,    -1,   139,    97,
      98,    -1,   143,    -1,    -1,   249,    -1,   105,   252,    -1,
      -1,   152,   256,    -1,   243,   232,    -1,    -1,    -1,    -1,
      -1,    -1,   251,    -1,   165,   269,    -1,    -1,   245,    -1,
     171,   172,    -1,   250,    -1,    -1,   253,    -1,    -1,    -1,
      -1,   139,    -1,    -1,    -1,   143,    -1,   264,   265,    -1,
      -1,    -1,    -1,    -1,   152,    -1,    -1,    -1,    -1,    -1,
       3,     4,     5,    -1,     7,   206,     9,   165,    11,    -1,
      -1,    -1,    -1,   171,   172,   216,    -1,    -1,    21,    -1,
      -1,    24,    25,    -1,    -1,    28,    29,   228,   229,    -1,
      33,    -1,    35,    36,    37,    -1,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    -1,    -1,   206,   250,
      -1,    -1,     7,    -1,    -1,    -1,    -1,   258,   216,    -1,
     261,    16,    -1,   264,    -1,    -1,    -1,    -1,    -1,    -1,
     228,   229,   273,    28,    -1,    30,    -1,    -1,    33,    -1,
      35,    36,    37,    38,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,   250,    -1,    49,    -1,    -1,    -1,    -1,    -1,
     258,    -1,    -1,   261,    -1,     3,   264,     5,     6,     7,
      -1,     9,    -1,    11,    -1,   273,    -1,    15,    16,    -1,
      18,    19,    20,    21,    -1,    -1,    24,    25,    -1,    -1,
      28,    29,    -1,    -1,    -1,    33,    -1,    35,    36,    37,
      -1,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,     3,    -1,     5,    -1,     7,    -1,     9,    -1,    11,
      -1,    -1,    -1,    15,    16,    -1,    18,    19,    20,    21,
      -1,    -1,    24,    25,    -1,    -1,    28,    29,    -1,    -1,
      -1,    33,    -1,    35,    36,    37,    -1,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,     3,    -1,     5,
      -1,     7,    -1,     9,    -1,    11,    -1,    -1,    -1,    15,
      16,    -1,    18,    19,    20,    21,    -1,    -1,    24,    25,
      -1,    -1,    28,    29,    -1,    -1,    -1,    33,    -1,    35,
      36,    37,    -1,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,     3,    -1,     5,    -1,     7,    -1,     9,
      -1,    11,    -1,    -1,    -1,    -1,    16,    -1,    -1,    -1,
      -1,    21,    -1,    -1,    24,    25,    -1,    -1,    28,    29,
      -1,    -1,    -1,    33,    -1,    35,    36,    37,    -1,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,     3,
      -1,     5,    -1,     7,     8,     9,    -1,    11,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    21,    -1,    -1,
      24,    25,    -1,    -1,    28,    29,    -1,    -1,    -1,    33,
      -1,    35,    36,    37,    -1,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,     3,    -1,     5,    -1,     7,
      -1,     9,    10,    11,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    21,    -1,    -1,    24,    25,    -1,    -1,
      28,    29,    -1,    -1,    -1,    33,    -1,    35,    36,    37,
      -1,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,     3,    -1,     5,    -1,     7,    -1,     9,    -1,    11,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    21,
      -1,    -1,    24,    25,    -1,    -1,    28,    29,    -1,    -1,
      -1,    33,    -1,    35,    36,    37,    -1,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,     3,    -1,     5,
      -1,     7,    -1,     9,    -1,    11,    -1,    -1,    -1,    -1,
      16,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    28,    -1,     3,    31,     5,    33,     7,    35,
       9,    -1,    11,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    -1,    -1,    -1,    -1,    -1,    -1,    28,
      -1,    30,    31,    -1,    33,    -1,    35,    -1,    -1,     7,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
       3,    -1,     5,    -1,     7,    -1,     9,    -1,    11,    -1,
      28,    -1,    30,    -1,    -1,    33,    -1,    35,    36,    37,
      38,    -1,    -1,    -1,    -1,    28,     7,     8,    31,    -1,
      33,    49,    35,    -1,    -1,    -1,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    -1,    28,    -1,    30,
      -1,    -1,    33,     7,    35,    36,    37,    38,    -1,    13,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    49,    -1,
       7,    -1,    -1,    -1,    28,    -1,    30,    -1,    -1,    33,
      -1,    35,    36,    37,    38,    -1,    -1,    -1,    -1,    -1,
      -1,    28,    -1,    30,    -1,    49,    33,    -1,    35,    36,
      37,    38,     0,    -1,    -1,    -1,     4,    -1,     6,    -1,
       8,    -1,    49,    -1,    -1,    -1,    14,    15,    16,    -1,
      18,    19,    20,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    34
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     5,     7,     9,    11,    15,    16,    18,    19,
      20,    21,    24,    25,    28,    29,    33,    35,    36,    37,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      51,    52,    53,    55,    56,    57,    58,    59,    60,    61,
      63,    64,    65,    66,    67,    68,    69,    70,    71,    72,
      73,    74,    75,    76,    81,    82,    83,    84,    85,    86,
      87,    88,    90,    92,    93,    94,    96,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   112,   113,   114,
     115,   116,   121,    53,    54,    59,    66,   111,    54,    54,
      54,    28,    33,    65,   117,   118,   119,    59,    59,    66,
     103,    57,    72,    26,    27,    59,     0,    52,    56,    16,
      52,    55,     7,    30,    38,    49,    62,    65,    88,    89,
      94,     3,    31,    54,    66,    95,   109,    32,    14,    32,
      63,     7,    62,    64,    65,    66,    77,    78,     4,    59,
      91,   111,    64,    59,    30,     4,    14,     6,    56,     8,
     111,    10,    59,   120,    11,    65,    14,    22,    97,    98,
      99,    17,    57,    13,    52,    59,    54,    30,    95,    91,
      91,    59,    59,    95,    54,    66,   111,     8,    65,    65,
      57,     7,    62,    65,    78,    57,    64,    77,    79,    80,
     114,     4,    54,    95,    54,    30,    54,    53,    54,    54,
      54,    14,    54,    54,    65,    57,    59,    97,    23,    97,
     100,    72,     5,     8,    54,     4,    59,    65,    57,     8,
      65,    57,    57,    65,    54,   114,    95,     4,    59,    59,
       6,     8,    12,    54,    10,    57,    12,    57,    57,    57,
      54,    95,    57,    65,    57,     3,    64,    79,     4,    54,
      59,    65,    34,   122,   123,    57,    54,    65,    59,    54,
      57,    59,    54,   123,    59,    12,    13,     6,    54,    54,
      11,    56,     4,    59,    65,    11,    56
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (self, YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex (self)
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value, self); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, VALUE self)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep, self)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    VALUE self;
#endif
{
  if (!yyvaluep)
    return;
  YYUSE (self);
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, VALUE self)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep, self)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
    VALUE self;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep, self);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule, VALUE self)
#else
static void
yy_reduce_print (yyvsp, yyrule, self)
    YYSTYPE *yyvsp;
    int yyrule;
    VALUE self;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       , self);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule, self); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, VALUE self)
#else
static void
yydestruct (yymsg, yytype, yyvaluep, self)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
    VALUE self;
#endif
{
  YYUSE (yyvaluep);
  YYUSE (self);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (VALUE self);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (VALUE self)
#else
int
yyparse (self)
    VALUE self;
#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 3:

/* Line 1455 of yacc.c  */
#line 159 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  rb_funcall(self, rb_intern("body:"), 1, (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 181 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                   (yyval.object) = rb_funcall(self, rb_intern("ast:exp_list:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 184 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                   (yyval.object) = rb_funcall(self, rb_intern("ast:exp_list:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 187 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                   (yyval.object) = (yyvsp[(2) - (2)].object);
                ;}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 190 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                   (yyval.object) = (yyvsp[(1) - (2)].object);
                ;}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 195 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                   (yyval.object) = (yyvsp[(3) - (5)].object);
                ;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 198 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                   (yyval.object) = rb_funcall(self, rb_intern("ast:exp_list:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 219 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    { (yyval.object) = rb_funcall(self, rb_intern("ast:super_exp:"), 2, INT2NUM(yylineno), Qnil); ;}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 220 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    { (yyval.object) = rb_funcall(self, rb_intern("ast:retry_exp:"), 2, INT2NUM(yylineno), Qnil); ;}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 221 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = (yyvsp[(3) - (5)].object);
                ;}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 224 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = (yyvsp[(1) - (3)].object);
                ;}
    break;

  case 37:

/* Line 1455 of yacc.c  */
#line 229 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:assign:to:"), 3, INT2NUM(yylineno), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object));
                ;}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 235 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:assign:to:many:"), 4, INT2NUM(yylineno), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object), Qtrue);
                ;}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 240 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:identifier:");
                ;}
    break;

  case 41:

/* Line 1455 of yacc.c  */
#line 245 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:identifier:");
                ;}
    break;

  case 42:

/* Line 1455 of yacc.c  */
#line 250 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:identifier:");
                ;}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 254 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:identifier:");
                ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 257 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node_from(self, "ast:identifier:", "match");
                ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 260 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node_from(self, "ast:identifier:", "class");
                ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 269 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 272 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 277 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:return_local_stmt:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 280 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:return_local_stmt:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 285 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:return_stmt:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 288 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:return_stmt:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 293 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:require_:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 296 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:require_:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 305 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:identity:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 308 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:constant:parent:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 313 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    { (yyval.object) = rb_intern("private"); ;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 314 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    { (yyval.object) = rb_intern("protected"); ;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 315 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    { (yyval.object) = rb_intern("public"); ;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 318 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:class:parent:body:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), Qnil, (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 323 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:class:parent:body:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (5)].object), (yyvsp[(4) - (5)].object), (yyvsp[(5) - (5)].object));
                ;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 336 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:param:var:"), 3, INT2NUM(yylineno), (yyvsp[(1) - (2)].object), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 341 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 344 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 347 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 352 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:param:var:default:"), 4, INT2NUM(yylineno), (yyvsp[(1) - (7)].object), (yyvsp[(2) - (7)].object), (yyvsp[(5) - (7)].object));
                ;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 357 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 360 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 365 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:method:expand:access:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 371 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:method:body:access:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 377 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:method:expand:access:owner:"), 5, INT2NUM(yylineno), (yyvsp[(3) - (4)].object), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object), (yyvsp[(2) - (4)].object));
                ;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 382 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:method:body:access:owner:"), 5, INT2NUM(yylineno), (yyvsp[(3) - (4)].object), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object), (yyvsp[(2) - (4)].object));
                ;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 387 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:body:access:"), 5, INT2NUM(yylineno), (yyvsp[(2) - (4)].object), (yyvsp[(3) - (4)].object), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object));
                ;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 390 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:body:access:"), 5,
                                  INT2NUM(yylineno), fy_terminal_node_from(self, "ast:identifier:", "[]"), (yyvsp[(4) - (5)].object), (yyvsp[(5) - (5)].object), (yyvsp[(1) - (5)].object));
                ;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 396 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:body:access:owner:"), 6, INT2NUM(yylineno), (yyvsp[(3) - (5)].object), (yyvsp[(4) - (5)].object), (yyvsp[(5) - (5)].object), (yyvsp[(1) - (5)].object), (yyvsp[(2) - (5)].object));
                ;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 399 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:body:access:owner:"), 6,
                                  INT2NUM(yylineno), fy_terminal_node_from(self, "ast:identifier:", "[]"), (yyvsp[(5) - (6)].object), (yyvsp[(6) - (6)].object), (yyvsp[(1) - (6)].object), (yyvsp[(2) - (6)].object));
                ;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 405 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:to:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 87:

/* Line 1455 of yacc.c  */
#line 408 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:to:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 411 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 420 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  // remove the trailing left paren and create an identifier.
                  (yyval.object) = fy_terminal_node(self, "ast:ruby_send:");
                ;}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 424 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  // remove the trailing left paren and create an identifier.
                  (yyval.object) = fy_terminal_node(self, "ast:ruby_send:");
                ;}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 429 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:to:ruby:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(1) - (3)].object), (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 432 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:to:ruby:"), 4, INT2NUM(yylineno), (yyvsp[(1) - (2)].object), Qnil, (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 442 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ruby_args:block:"), 3, INT2NUM(yylineno), Qnil, (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 445 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ruby_args:block:"), 3, INT2NUM(yylineno), (yyvsp[(1) - (3)].object), (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 448 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ruby_args:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 451 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ruby_args:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 456 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:to:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 459 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:to:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (5)].object), (yyvsp[(5) - (5)].object), (yyvsp[(1) - (5)].object));
                ;}
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 462 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:to:"), 4,
                                  INT2NUM(yylineno), fy_terminal_node_from(self, "ast:identifier:", "[]"), (yyvsp[(3) - (4)].object), (yyvsp[(1) - (4)].object));
                ;}
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 468 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:to:ruby:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(1) - (3)].object), (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 101:

/* Line 1455 of yacc.c  */
#line 474 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:arg:"), 3, INT2NUM(yylineno), (yyvsp[(1) - (2)].object), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 102:

/* Line 1455 of yacc.c  */
#line 477 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:arg:"), 3, INT2NUM(yylineno), (yyvsp[(1) - (3)].object), (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 103:

/* Line 1455 of yacc.c  */
#line 480 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:arg:ary:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 483 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:arg:ary:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (4)].object), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object));
                ;}
    break;

  case 105:

/* Line 1455 of yacc.c  */
#line 488 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = (yyvsp[(1) - (1)].object);
                ;}
    break;

  case 106:

/* Line 1455 of yacc.c  */
#line 491 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = (yyvsp[(2) - (3)].object);
                ;}
    break;

  case 107:

/* Line 1455 of yacc.c  */
#line 494 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = (yyvsp[(1) - (1)].object);
                ;}
    break;

  case 108:

/* Line 1455 of yacc.c  */
#line 497 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = (yyvsp[(2) - (2)].object);
                ;}
    break;

  case 109:

/* Line 1455 of yacc.c  */
#line 502 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:try_block:ex_handlers:finally_block:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (4)].object), (yyvsp[(3) - (4)].object), (yyvsp[(4) - (4)].object));
                ;}
    break;

  case 110:

/* Line 1455 of yacc.c  */
#line 505 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:try_block:ex_handlers:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 111:

/* Line 1455 of yacc.c  */
#line 510 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ex_handler:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 112:

/* Line 1455 of yacc.c  */
#line 513 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ex_handler:cond:"), 3, INT2NUM(yylineno), (yyvsp[(3) - (3)].object), (yyvsp[(2) - (3)].object));
                ;}
    break;

  case 113:

/* Line 1455 of yacc.c  */
#line 516 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ex_handler:cond:var:"), 4, INT2NUM(yylineno), (yyvsp[(5) - (5)].object), (yyvsp[(2) - (5)].object), (yyvsp[(4) - (5)].object));
                ;}
    break;

  case 114:

/* Line 1455 of yacc.c  */
#line 521 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 115:

/* Line 1455 of yacc.c  */
#line 524 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 116:

/* Line 1455 of yacc.c  */
#line 529 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 117:

/* Line 1455 of yacc.c  */
#line 532 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 118:

/* Line 1455 of yacc.c  */
#line 535 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 119:

/* Line 1455 of yacc.c  */
#line 540 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = (yyvsp[(2) - (2)].object);
                ;}
    break;

  case 120:

/* Line 1455 of yacc.c  */
#line 545 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:fixnum:");
                ;}
    break;

  case 121:

/* Line 1455 of yacc.c  */
#line 549 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:number:");
                ;}
    break;

  case 122:

/* Line 1455 of yacc.c  */
#line 553 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:string:");
                ;}
    break;

  case 123:

/* Line 1455 of yacc.c  */
#line 556 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:string:");
                ;}
    break;

  case 124:

/* Line 1455 of yacc.c  */
#line 560 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:symbol:");
                ;}
    break;

  case 125:

/* Line 1455 of yacc.c  */
#line 564 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:regexp:");
                ;}
    break;

  case 126:

/* Line 1455 of yacc.c  */
#line 569 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:fixnum:base:"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(16));
                ;}
    break;

  case 127:

/* Line 1455 of yacc.c  */
#line 575 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:fixnum:base:"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(8));
                ;}
    break;

  case 128:

/* Line 1455 of yacc.c  */
#line 581 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:fixnum:base:"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(2));
                ;}
    break;

  case 142:

/* Line 1455 of yacc.c  */
#line 602 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = (yyvsp[(1) - (1)].object);
                ;}
    break;

  case 143:

/* Line 1455 of yacc.c  */
#line 605 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:array:"), 2, INT2NUM(yylineno), (yyvsp[(3) - (5)].object));
                ;}
    break;

  case 144:

/* Line 1455 of yacc.c  */
#line 610 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 145:

/* Line 1455 of yacc.c  */
#line 613 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object));
                ;}
    break;

  case 146:

/* Line 1455 of yacc.c  */
#line 616 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = (yyvsp[(1) - (2)].object);
                ;}
    break;

  case 147:

/* Line 1455 of yacc.c  */
#line 621 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:array:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 148:

/* Line 1455 of yacc.c  */
#line 626 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:hash:"), 2, INT2NUM(yylineno), (yyvsp[(3) - (5)].object));
                ;}
    break;

  case 149:

/* Line 1455 of yacc.c  */
#line 629 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:hash:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 150:

/* Line 1455 of yacc.c  */
#line 634 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:block:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 151:

/* Line 1455 of yacc.c  */
#line 637 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:block:args:"), 3, INT2NUM(yylineno), (yyvsp[(5) - (5)].object), (yyvsp[(2) - (5)].object));
                ;}
    break;

  case 152:

/* Line 1455 of yacc.c  */
#line 642 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:tuple:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (3)].object));
                ;}
    break;

  case 153:

/* Line 1455 of yacc.c  */
#line 647 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:range:to:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (6)].object), (yyvsp[(5) - (6)].object));
                ;}
    break;

  case 156:

/* Line 1455 of yacc.c  */
#line 656 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 157:

/* Line 1455 of yacc.c  */
#line 659 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 158:

/* Line 1455 of yacc.c  */
#line 664 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 159:

/* Line 1455 of yacc.c  */
#line 667 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 160:

/* Line 1455 of yacc.c  */
#line 672 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:key:value:into:"), 4, INT2NUM(yylineno), (yyvsp[(1) - (5)].object), (yyvsp[(5) - (5)].object), Qnil);
                ;}
    break;

  case 161:

/* Line 1455 of yacc.c  */
#line 675 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:key:value:into:"), 4, INT2NUM(yylineno), (yyvsp[(4) - (8)].object), (yyvsp[(8) - (8)].object), (yyvsp[(1) - (8)].object));
                ;}
    break;

  case 162:

/* Line 1455 of yacc.c  */
#line 680 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:match_expr:body:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (8)].object), (yyvsp[(6) - (8)].object));
                ;}
    break;

  case 163:

/* Line 1455 of yacc.c  */
#line 685 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 164:

/* Line 1455 of yacc.c  */
#line 688 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 165:

/* Line 1455 of yacc.c  */
#line 693 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:match_clause:body:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (4)].object), (yyvsp[(4) - (4)].object));
                ;}
    break;

  case 166:

/* Line 1455 of yacc.c  */
#line 696 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:match_clause:body:arg:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (7)].object), (yyvsp[(7) - (7)].object), (yyvsp[(5) - (7)].object));
                ;}
    break;



/* Line 1455 of yacc.c  */
#line 2878 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (self, YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (self, yymsg);
	  }
	else
	  {
	    yyerror (self, YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval, self);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp, self);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (self, YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval, self);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp, self);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 701 "/home/bakkdoor/projekte/fancy/fancy-lang/boot/parser/parser.y"



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
  rb_funcall(self, rb_intern("ast:parse_error:"), 2, INT2NUM(yylineno), rb_str_new2(yytext));
  return 1;
}


