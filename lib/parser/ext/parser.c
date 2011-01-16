/* A Bison parser, made by GNU Bison 2.4.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
   2009, 2010 Free Software Foundation, Inc.
   
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
#define YYBISON_VERSION "2.4.3"

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
#line 1 "parser.y"

#include "ruby.h"

int yyerror(VALUE, char *s);
int yylex(VALUE);

VALUE fy_terminal_node(VALUE, char *);
VALUE fy_terminal_node_from(VALUE, char *, char*);

extern int yylineno;
extern char *yytext;



/* Line 189 of yacc.c  */
#line 87 "parser.c"

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

/* Line 214 of yacc.c  */
#line 18 "parser.y"

  VALUE object;
  ID    symbol;



/* Line 214 of yacc.c  */
#line 180 "parser.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 192 "parser.c"

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
# if defined YYENABLE_NLS && YYENABLE_NLS
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
#define YYFINAL  111
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1207

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  51
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  75
/* YYNRULES -- Number of rules.  */
#define YYNRULES  169
/* YYNRULES -- Number of states.  */
#define YYNSTATES  285

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   305

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
      45,    46,    47,    48,    49,    50
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     6,     8,    10,    13,    15,    18,
      19,    21,    23,    25,    27,    30,    33,    36,    42,    46,
      52,    54,    56,    58,    60,    62,    64,    66,    68,    70,
      72,    74,    76,    78,    80,    82,    84,    90,    94,    99,
     101,   105,   107,   109,   111,   113,   115,   117,   119,   121,
     123,   127,   130,   132,   135,   137,   140,   143,   145,   147,
     149,   152,   155,   158,   160,   164,   170,   172,   174,   176,
     178,   180,   182,   185,   187,   190,   193,   201,   203,   207,
     211,   215,   220,   225,   230,   236,   242,   249,   252,   255,
     257,   259,   261,   265,   268,   271,   275,   277,   280,   284,
     290,   295,   298,   302,   305,   309,   313,   318,   320,   324,
     326,   329,   334,   338,   341,   345,   351,   353,   356,   358,
     361,   362,   365,   367,   369,   371,   373,   375,   377,   379,
     381,   383,   385,   387,   389,   391,   393,   395,   397,   399,
     401,   403,   405,   407,   409,   411,   417,   419,   424,   427,
     431,   437,   441,   443,   445,   451,   455,   462,   464,   466,
     468,   471,   473,   477,   483,   492,   501,   503,   506,   511
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      52,     0,    -1,    -1,    57,    -1,    54,    -1,    16,    -1,
      53,    53,    -1,    17,    -1,    54,    17,    -1,    -1,    54,
      -1,    60,    -1,    61,    -1,    56,    -1,    57,    56,    -1,
      53,    57,    -1,    57,    53,    -1,     6,    55,    57,    55,
       7,    -1,     6,    55,     7,    -1,     5,    55,    57,    55,
       7,    -1,    62,    -1,    70,    -1,    71,    -1,    72,    -1,
      78,    -1,    73,    -1,    98,    -1,   123,    -1,    89,    -1,
      94,    -1,    92,    -1,    95,    -1,   111,    -1,    68,    -1,
      26,    -1,    25,    -1,     3,    55,    61,    55,     4,    -1,
      61,    31,    55,    -1,    68,    33,    55,    61,    -1,    63,
      -1,    69,    33,   113,    -1,    50,    -1,    40,    -1,    37,
      -1,    36,    -1,    34,    -1,    29,    -1,    74,    -1,    67,
      -1,    68,    -1,    69,    15,    68,    -1,    19,    61,    -1,
      19,    -1,    20,    61,    -1,    20,    -1,    21,   105,    -1,
      21,    68,    -1,    76,    -1,    77,    -1,    65,    -1,    74,
      65,    -1,    30,    27,    -1,    30,    28,    -1,    30,    -1,
      29,    74,    58,    -1,    29,    74,    18,    74,    58,    -1,
      83,    -1,    84,    -1,    85,    -1,    86,    -1,    87,    -1,
      88,    -1,    66,    67,    -1,    79,    -1,    80,    79,    -1,
      80,    82,    -1,    66,    67,     3,    55,    61,    55,     4,
      -1,    81,    -1,    82,    55,    81,    -1,    75,    80,    58,
      -1,    75,    67,    58,    -1,    75,    68,    80,    58,    -1,
      75,    68,    67,    58,    -1,    75,    64,    67,    58,    -1,
      75,     8,     9,    67,    58,    -1,    75,    68,    64,    67,
      58,    -1,    75,    68,     8,     9,    67,    58,    -1,    61,
      67,    -1,    61,    96,    -1,    96,    -1,    38,    -1,    39,
      -1,    61,    90,    93,    -1,    90,    93,    -1,     4,   116,
      -1,   113,     4,   116,    -1,     4,    -1,   113,     4,    -1,
      61,    64,    97,    -1,    61,    64,    31,    55,    97,    -1,
      61,     8,    61,     9,    -1,    64,    97,    -1,    61,    91,
      93,    -1,    66,    97,    -1,    66,    55,    97,    -1,    96,
      66,    97,    -1,    96,    66,    55,    97,    -1,    68,    -1,
       3,    61,     4,    -1,   111,    -1,    32,    61,    -1,    22,
      58,   101,   102,    -1,    22,    58,   100,    -1,    23,    58,
      -1,    23,    61,    58,    -1,    23,    61,    13,    67,    58,
      -1,    99,    -1,   100,    99,    -1,    99,    -1,   101,    99,
      -1,    -1,    24,    58,    -1,    41,    -1,    45,    -1,    46,
      -1,    47,    -1,    48,    -1,    49,    -1,    42,    -1,    43,
      -1,    44,    -1,   103,    -1,   108,    -1,   109,    -1,   110,
      -1,   104,    -1,   105,    -1,   106,    -1,   115,    -1,   112,
      -1,   107,    -1,   116,    -1,   117,    -1,   118,    -1,   114,
      -1,     8,    55,   113,    55,     9,    -1,    61,    -1,   113,
      15,    55,    61,    -1,   113,    15,    -1,     8,    55,     9,
      -1,    10,    55,   122,    55,    11,    -1,    10,    55,    11,
      -1,    59,    -1,    58,    -1,    12,   119,    12,    55,    58,
      -1,     3,   113,     4,    -1,     3,    61,    31,    31,    61,
       4,    -1,   121,    -1,   120,    -1,    67,    -1,   120,    67,
      -1,    67,    -1,   121,    15,    67,    -1,    61,    55,    13,
      55,    61,    -1,   122,    15,    55,    61,    55,    13,    55,
      61,    -1,    34,    61,    14,     6,    55,   124,    55,     7,
      -1,   125,    -1,   124,   125,    -1,    35,    61,    14,    57,
      -1,    35,    61,    14,    12,   119,    12,    57,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   160,   160,   161,   166,   167,   168,   171,   172,   175,
     176,   179,   180,   183,   186,   189,   192,   197,   200,   205,
     210,   211,   212,   213,   216,   217,   218,   219,   220,   221,
     222,   223,   224,   225,   226,   227,   228,   231,   236,   239,
     242,   247,   252,   257,   261,   264,   267,   272,   273,   276,
     279,   284,   287,   292,   295,   300,   303,   308,   309,   312,
     315,   320,   321,   322,   325,   330,   335,   336,   337,   338,
     339,   340,   343,   348,   351,   354,   359,   364,   367,   372,
     378,   384,   389,   394,   397,   403,   406,   412,   415,   418,
     427,   431,   436,   439,   449,   452,   455,   458,   463,   466,
     469,   473,   478,   484,   487,   490,   493,   498,   501,   504,
     507,   512,   515,   520,   523,   526,   531,   534,   539,   542,
     545,   550,   555,   559,   563,   566,   570,   574,   579,   585,
     591,   597,   598,   599,   600,   601,   602,   603,   604,   605,
     606,   607,   608,   609,   612,   615,   620,   623,   626,   631,
     636,   639,   644,   647,   650,   655,   660,   665,   666,   669,
     672,   677,   680,   685,   688,   693,   698,   701,   706,   709
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "LPAREN", "RPAREN", "AT_LCURLY",
  "LCURLY", "RCURLY", "LBRACKET", "RBRACKET", "LHASH", "RHASH", "STAB",
  "ARROW", "THIN_ARROW", "COMMA", "SEMI", "NL", "COLON", "RETURN_LOCAL",
  "RETURN", "REQUIRE", "TRY", "CATCH", "FINALLY", "RETRY", "SUPER",
  "PRIVATE", "PROTECTED", "CLASS", "DEF", "DOT", "DOLLAR", "EQUALS",
  "MATCH", "CASE", "IDENTIFIER", "SELECTOR", "RUBY_SEND_OPEN",
  "RUBY_OPER_OPEN", "CONSTANT", "INTEGER_LITERAL", "HEX_LITERAL",
  "OCT_LITERAL", "BIN_LITERAL", "DOUBLE_LITERAL", "STRING_LITERAL",
  "MULTI_STRING_LITERAL", "SYMBOL_LITERAL", "REGEX_LITERAL", "OPERATOR",
  "$accept", "programm", "delim", "nls", "space", "code",
  "expression_list", "expression_block", "partial_expression_block",
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
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    51,    52,    52,    53,    53,    53,    54,    54,    55,
      55,    56,    56,    57,    57,    57,    57,    58,    58,    59,
      60,    60,    60,    60,    61,    61,    61,    61,    61,    61,
      61,    61,    61,    61,    61,    61,    61,    61,    62,    62,
      63,    64,    65,    66,    67,    67,    67,    68,    68,    69,
      69,    70,    70,    71,    71,    72,    72,    73,    73,    74,
      74,    75,    75,    75,    76,    77,    78,    78,    78,    78,
      78,    78,    79,    80,    80,    80,    81,    82,    82,    83,
      84,    85,    86,    87,    87,    88,    88,    89,    89,    89,
      90,    91,    92,    92,    93,    93,    93,    93,    94,    94,
      94,    94,    95,    96,    96,    96,    96,    97,    97,    97,
      97,    98,    98,    99,    99,    99,   100,   100,   101,   101,
     101,   102,   103,   104,   105,   105,   106,   107,   108,   109,
     110,   111,   111,   111,   111,   111,   111,   111,   111,   111,
     111,   111,   111,   111,   112,   112,   113,   113,   113,   114,
     115,   115,   116,   116,   116,   117,   118,   119,   119,   120,
     120,   121,   121,   122,   122,   123,   124,   124,   125,   125
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     1,     1,     1,     2,     1,     2,     0,
       1,     1,     1,     1,     2,     2,     2,     5,     3,     5,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     5,     3,     4,     1,
       3,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       3,     2,     1,     2,     1,     2,     2,     1,     1,     1,
       2,     2,     2,     1,     3,     5,     1,     1,     1,     1,
       1,     1,     2,     1,     2,     2,     7,     1,     3,     3,
       3,     4,     4,     4,     5,     5,     6,     2,     2,     1,
       1,     1,     3,     2,     2,     3,     1,     2,     3,     5,
       4,     2,     3,     2,     3,     3,     4,     1,     3,     1,
       2,     4,     3,     2,     3,     5,     1,     2,     1,     2,
       0,     2,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     5,     1,     4,     2,     3,
       5,     3,     1,     1,     5,     3,     6,     1,     1,     1,
       2,     1,     3,     5,     8,     8,     1,     2,     4,     7
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     9,     9,     9,     9,     0,     5,     7,    52,
      54,     0,     0,    35,    34,    46,    63,    45,    44,    43,
      90,    42,   122,   128,   129,   130,   123,   124,   125,   126,
     127,    41,     0,     0,     4,    13,     3,   153,   152,    11,
      12,    20,    39,     0,    59,     0,    48,    33,     0,    21,
      22,    23,    25,    47,     0,    57,    58,    24,    66,    67,
      68,    69,    70,    71,    28,     0,    30,    29,    31,    89,
      26,   131,   135,   136,   137,   140,   132,   133,   134,    32,
     139,   144,   138,   141,   142,   143,    27,    10,     0,   146,
      33,     0,     0,     0,     0,     0,    46,    45,   159,     0,
     158,   157,    51,    53,    56,    55,   120,     0,    61,    62,
       0,     1,     0,    15,     8,    16,    14,     0,     9,    91,
       0,    87,     0,     0,    88,     0,     0,   107,   101,   109,
       0,   103,     9,     0,     0,    60,     0,     0,     0,    48,
       0,    73,     0,    96,   146,    93,     0,     0,     9,     9,
     155,     9,     9,    18,     9,   149,     9,   151,     9,     9,
       9,   160,     0,     0,   116,   112,     0,     0,    64,     0,
       6,     0,    37,     9,    98,    92,   102,   146,   110,   104,
       0,    50,    40,     0,     0,    72,    80,     0,     0,     0,
       0,    79,     0,    74,    77,     9,    94,    97,     0,   105,
       0,     0,     0,     4,     0,     0,     0,     0,     9,     0,
       0,   162,   113,     0,   117,     0,   119,   111,     0,     9,
     100,     0,   108,    38,     0,    83,     0,     0,    82,    81,
      72,     0,    95,   106,    36,     0,   147,    19,    17,   145,
       9,     0,   150,   154,     0,   114,   121,    65,     0,    99,
      84,     0,    85,     9,     0,    78,   156,     0,     9,     0,
       0,     9,   166,    86,     0,     0,   163,     0,   115,     0,
       0,   167,     9,     9,     0,   165,     0,     0,     0,   168,
      76,   164,     0,     0,   169
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    32,   115,    87,   172,    35,   113,    37,    38,    39,
      40,    41,    42,    43,    44,    45,    46,    90,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,   141,   142,
     194,   195,    58,    59,    60,    61,    62,    63,    64,    65,
     123,    66,   145,    67,    68,    69,   128,    70,   164,   165,
     166,   217,    71,    72,    73,    74,    75,    76,    77,    78,
      79,    80,   146,    81,    82,    83,    84,    85,    99,   100,
     101,   159,    86,   261,   262
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -142
static const yytype_int16 yypact[] =
{
     629,   725,     7,     7,     7,     7,    -9,  -142,  -142,   917,
     917,    54,    23,  -142,  -142,   -19,    87,   917,  -142,  -142,
    -142,  -142,  -142,  -142,  -142,  -142,  -142,  -142,  -142,  -142,
    -142,  -142,    34,   629,    40,  -142,   629,  -142,  -142,  -142,
    1017,  -142,  -142,  1037,  -142,   965,  -142,   -10,    16,  -142,
    -142,  -142,  -142,   -19,     1,  -142,  -142,  -142,  -142,  -142,
    -142,  -142,  -142,  -142,  -142,   773,  -142,  -142,  -142,    29,
    -142,  -142,  -142,  -142,  -142,  -142,  -142,  -142,  -142,  -142,
    -142,  -142,  -142,  -142,  -142,  -142,  -142,    40,   917,  1132,
    -142,    49,   629,   581,   821,   869,  -142,  -142,    59,    28,
      -9,    66,  1017,  1017,  -142,  -142,    74,     4,  -142,  -142,
    1060,  -142,   629,   629,  -142,     2,  -142,   917,     7,  -142,
     990,  -142,   773,   773,    29,   917,   917,  -142,  -142,  -142,
    1037,  -142,     7,    46,   917,  -142,    60,    -9,    -9,    23,
     397,  -142,    10,    98,  1017,  -142,    69,   965,  1084,    -5,
    -142,  1172,   629,  -142,   629,  -142,    50,  -142,  1084,    72,
       7,  -142,    -9,   917,    53,    74,    93,   -19,  -142,   101,
       2,  1099,  -142,     7,  -142,  -142,  -142,   471,   335,  -142,
     917,  -142,    94,    -9,    23,  -142,  -142,   102,    -9,    23,
      10,  -142,    -9,  -142,  -142,    11,  -142,    98,  1037,  -142,
     130,   917,   917,    40,   128,   129,   131,   124,     7,   127,
      23,  -142,  -142,   506,  -142,    23,  -142,  -142,     8,     7,
    -142,  1037,  -142,  1017,    23,  -142,    -9,    23,  -142,  -142,
     138,    29,  -142,  -142,  -142,   491,  1017,  -142,  -142,  -142,
       7,   917,  -142,  -142,    -9,  -142,  -142,  -142,   107,  -142,
    -142,    23,  -142,     7,    -9,  -142,  -142,   917,  1084,    23,
     917,    15,  -142,  -142,   917,   138,  1017,   136,  -142,  1117,
     137,  -142,  1084,     7,   677,  -142,   147,   917,    -9,   629,
    -142,  1017,   149,   629,   629
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -142,  -142,    13,     6,    57,   -28,     3,   194,  -142,  -142,
      62,  -142,  -142,    89,   -52,    22,   204,     0,  -142,  -142,
    -142,  -142,  -142,    -8,  -142,  -142,  -142,  -142,  -138,    27,
     -66,  -142,  -142,  -142,  -142,  -142,  -142,  -142,  -142,   288,
    -142,  -142,     9,  -142,  -142,   313,    33,  -142,   -43,  -142,
    -142,  -142,  -142,  -142,   157,  -142,  -142,  -142,  -142,  -142,
      25,  -142,    14,  -142,  -142,  -141,  -142,  -142,  -109,  -142,
    -142,  -142,  -142,  -142,   -91
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -162
static const yytype_int16 yytable[] =
{
      47,   135,   196,    36,   193,   -49,    34,   107,   116,   136,
       3,   104,     8,    33,     3,    91,     3,   -75,     7,     8,
      96,    21,   167,   132,     8,    97,   201,    18,     8,     3,
      96,   133,     8,    47,   111,    97,    47,    18,    19,    34,
     160,    21,    34,   127,    21,   127,   112,    19,    21,   134,
     260,    31,   193,   150,   140,   135,   232,   114,    88,    92,
      93,    94,    95,    89,   151,   151,    19,     8,   129,   183,
     129,   102,   103,   197,  -161,    96,   138,  -118,   131,   110,
      97,   162,    18,    96,   151,   116,    21,   208,    97,     8,
      18,   147,    47,    47,    21,   152,   154,   163,    34,    34,
      27,    28,   130,     2,     3,    33,    33,   219,   156,   151,
       6,   226,    47,    47,   108,   109,   163,   215,    34,    34,
     127,    34,   214,   216,   116,   112,   116,   144,   170,   120,
     127,   175,   176,   181,   234,   237,   238,   240,   242,    91,
     239,   253,   260,   137,   275,   129,   147,   127,   182,   273,
     148,   280,    47,   174,    47,   129,   144,   158,   203,   218,
     203,   283,   138,   179,   192,   255,   135,   190,   105,   282,
     271,     0,   129,     0,     0,     0,    34,     0,   120,   171,
     199,     0,     0,   170,   144,   144,     0,   177,   178,   180,
       0,   120,   120,     0,     0,     0,   144,     0,   127,   120,
       0,     0,     0,     0,   198,   200,   106,     0,   202,   204,
      98,   205,   192,   206,     0,   207,   209,   210,     0,     0,
       0,   127,     0,   129,     0,   213,     0,     0,     0,   188,
     221,   233,     0,   120,     0,     0,     0,   120,     0,     0,
       0,     0,   223,     0,   121,     0,   129,   120,     0,     0,
       0,   116,   231,   254,   249,     0,   116,     0,   139,     0,
     120,     0,     0,   235,   236,   241,   120,   120,     0,     0,
       0,     0,     0,     0,    47,     0,   248,   279,     0,    47,
      34,     0,     0,    47,    47,    34,   284,    33,     0,   203,
      34,     0,     0,   121,     0,     0,    33,   257,     0,     0,
       0,   168,   120,   258,   161,     0,   121,   121,     0,     0,
     264,     0,   120,     0,   121,   267,     0,     0,   270,   266,
       0,     0,   269,     0,   120,   120,   272,     0,   122,   276,
     277,     0,     0,   186,     0,     0,   191,     0,     0,   281,
     210,   184,   185,   117,   189,     0,     0,   120,   121,     0,
       0,     0,   121,   124,     0,   120,     0,   212,   120,     0,
       0,   120,   121,     0,    96,     0,   211,     0,     0,    97,
     120,    18,    19,    20,   119,   121,     0,   122,   225,     0,
       0,   121,   121,   228,   229,    31,     0,   224,     0,     0,
     122,   122,   227,     0,     0,     0,   230,     0,   122,     0,
       0,     0,   124,     0,   243,   187,     0,   245,     0,   246,
       0,     0,   247,     0,     0,   124,   124,   121,   250,     0,
       0,   252,     0,   124,     0,     0,    96,   121,     0,     0,
     251,    97,   122,    18,    19,     0,   122,     0,     0,   121,
     121,     0,     0,     0,     0,   263,   122,    31,   259,     0,
       0,     0,     0,   268,     0,     0,     0,   124,   265,   122,
       0,   124,   121,     0,     0,   122,   122,     0,     0,     0,
     121,   124,     0,   121,     0,   222,   121,     0,     0,   117,
       0,     0,    98,     0,   124,   121,     0,     0,     0,     0,
     124,   124,     0,     0,     0,   256,     0,     0,     0,   117,
      96,   122,   149,     0,     0,    97,     0,    18,    19,    20,
     119,   122,     3,     0,   117,     0,     0,     0,     0,   244,
      96,    31,   118,   122,   122,    97,   124,    18,    19,    20,
     119,     0,     0,     0,     0,    96,   124,   118,     0,     0,
      97,    31,    18,    19,    20,   119,   122,     0,   124,   124,
       0,     0,     0,     0,   122,     0,    31,   122,     0,     0,
     122,     0,     0,     0,     0,     0,     0,     0,     0,   122,
       0,   124,     0,     0,     0,     0,     0,     0,     0,   124,
       0,     0,   124,     0,     1,   124,     2,     3,   153,     4,
       0,     5,     0,     6,   124,     0,     0,     7,     8,     0,
       9,    10,    11,    12,     0,     0,    13,    14,     0,     0,
      15,    16,     0,     0,     0,    17,     0,    18,    19,    20,
       0,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,     1,     0,     2,     3,     0,     4,     0,     5,
       0,     6,     0,     0,     0,     7,     8,     0,     9,    10,
      11,    12,     0,     0,    13,    14,     0,     0,    15,    16,
       0,     0,     0,    17,     0,    18,    19,    20,     0,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
       1,     0,     2,     3,     0,     4,     0,     5,     0,   278,
       0,     0,     0,     7,     8,     0,     9,    10,    11,    12,
       0,     0,    13,    14,     0,     0,    15,    16,     0,     0,
       0,    17,     0,    18,    19,    20,     0,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,     1,     0,
       2,     3,     0,     4,     0,     5,     0,     6,     0,     0,
       0,     0,     8,     0,     0,     0,     0,    12,     0,     0,
      13,    14,     0,     0,    15,    16,     0,     0,     0,    17,
       0,    18,    19,    20,     0,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,    31,     1,   143,     2,     3,
       0,     4,     0,     5,     0,     6,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    12,     0,     0,    13,    14,
       0,     0,    15,    16,     0,     0,     0,    17,     0,    18,
      19,    20,     0,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,     1,     0,     2,     3,     0,     4,
     155,     5,     0,     6,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    12,     0,     0,    13,    14,     0,     0,
      15,    16,     0,     0,     0,    17,     0,    18,    19,    20,
       0,    21,    22,    23,    24,    25,    26,    27,    28,    29,
      30,    31,     1,     0,     2,     3,     0,     4,     0,     5,
     157,     6,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    12,     0,     0,    13,    14,     0,     0,    15,    16,
       0,     0,     0,    17,     0,    18,    19,    20,     0,    21,
      22,    23,    24,    25,    26,    27,    28,    29,    30,    31,
       1,     0,     2,     3,     0,     4,     0,     5,     0,     6,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    12,
       0,     0,    13,    14,     0,     0,    15,    16,     0,     0,
       0,    17,     0,    18,    19,    20,     0,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,   125,     0,
       2,     3,     0,     4,     0,     5,     0,     6,     0,     0,
       0,     0,     8,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   125,    96,     2,     3,   126,     4,    97,
       5,    18,     6,     0,     0,    21,    22,    23,    24,    25,
      26,    27,    28,    29,    30,     0,     0,     0,     0,    96,
       0,   173,   126,     0,    97,   117,    18,     0,     0,     0,
      21,    22,    23,    24,    25,    26,    27,    28,    29,    30,
     125,     0,     2,     3,     0,     4,    96,     5,   118,     6,
       0,    97,     0,    18,    19,    20,   119,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    96,    31,   117,   126,
       0,    97,     0,    18,   169,     0,     0,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,     0,     0,    96,
       0,   118,   117,     0,    97,     0,    18,    19,    20,   119,
       0,     8,     0,     0,     0,     0,     0,   117,   220,     0,
      31,     0,     0,    96,     0,   118,     0,     0,    97,     0,
      18,    19,    20,   119,     0,   117,     0,     0,    96,     0,
     118,   274,     0,    97,    31,    18,    19,    20,   119,     0,
     117,     0,     0,     0,     0,     0,    96,     0,   118,    31,
       0,    97,     0,    18,    19,    20,   119,     0,     0,     0,
       0,    96,     0,   149,     0,     0,    97,    31,    18,    19,
      20,   119,  -148,     0,     0,     0,  -148,     0,     0,  -148,
       0,  -148,    31,     0,     0,     0,     0,  -148,  -148,     8,
       0,  -148,  -148,  -148,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,  -148
};

static const yytype_int16 yycheck[] =
{
       0,    53,   143,     0,   142,    15,     0,    15,    36,     8,
       6,    11,    17,     0,     6,     1,     6,     6,    16,    17,
      29,    40,    18,    33,    17,    34,    31,    36,    17,     6,
      29,    15,    17,    33,     0,    34,    36,    36,    37,    33,
      12,    40,    36,    43,    40,    45,    33,    37,    40,    33,
      35,    50,   190,     4,    54,   107,   197,    17,     1,     2,
       3,     4,     5,     1,    15,    15,    37,    17,    43,     9,
      45,     9,    10,     4,    15,    29,    54,    24,    45,    17,
      34,    15,    36,    29,    15,   113,    40,    15,    34,    17,
      36,    69,    92,    93,    40,    92,    93,    23,    92,    93,
      46,    47,    45,     5,     6,    92,    93,     6,    94,    15,
      12,     9,   112,   113,    27,    28,    23,    24,   112,   113,
     120,   115,   165,   166,   152,   112,   154,    65,   115,    40,
     130,   122,   123,   133,     4,     7,     7,    13,    11,   125,
       9,     3,    35,    54,     7,   120,   124,   147,   134,    13,
      88,     4,   152,   120,   154,   130,    94,    95,   152,   167,
     154,    12,   140,   130,   142,   231,   218,   140,    11,   278,
     261,    -1,   147,    -1,    -1,    -1,   170,    -1,    89,   117,
     147,    -1,    -1,   170,   122,   123,    -1,   125,   126,   132,
      -1,   102,   103,    -1,    -1,    -1,   134,    -1,   198,   110,
      -1,    -1,    -1,    -1,   147,   148,    12,    -1,   151,   152,
       6,   154,   190,   156,    -1,   158,   159,   160,    -1,    -1,
      -1,   221,    -1,   198,    -1,   163,    -1,    -1,    -1,   140,
     173,   198,    -1,   144,    -1,    -1,    -1,   148,    -1,    -1,
      -1,    -1,   180,    -1,    40,    -1,   221,   158,    -1,    -1,
      -1,   279,   195,   231,   221,    -1,   284,    -1,    54,    -1,
     171,    -1,    -1,   201,   202,   208,   177,   178,    -1,    -1,
      -1,    -1,    -1,    -1,   274,    -1,   219,   274,    -1,   279,
     274,    -1,    -1,   283,   284,   279,   283,   274,    -1,   283,
     284,    -1,    -1,    89,    -1,    -1,   283,   240,    -1,    -1,
      -1,   107,   213,   241,   100,    -1,   102,   103,    -1,    -1,
     253,    -1,   223,    -1,   110,   258,    -1,    -1,   261,   257,
      -1,    -1,   260,    -1,   235,   236,   264,    -1,    40,   272,
     273,    -1,    -1,   139,    -1,    -1,   142,    -1,    -1,   277,
     283,   137,   138,     8,   140,    -1,    -1,   258,   144,    -1,
      -1,    -1,   148,    40,    -1,   266,    -1,   163,   269,    -1,
      -1,   272,   158,    -1,    29,    -1,   162,    -1,    -1,    34,
     281,    36,    37,    38,    39,   171,    -1,    89,   184,    -1,
      -1,   177,   178,   189,   190,    50,    -1,   183,    -1,    -1,
     102,   103,   188,    -1,    -1,    -1,   192,    -1,   110,    -1,
      -1,    -1,    89,    -1,   210,     8,    -1,   213,    -1,   215,
      -1,    -1,   218,    -1,    -1,   102,   103,   213,   224,    -1,
      -1,   227,    -1,   110,    -1,    -1,    29,   223,    -1,    -1,
     226,    34,   144,    36,    37,    -1,   148,    -1,    -1,   235,
     236,    -1,    -1,    -1,    -1,   251,   158,    50,   244,    -1,
      -1,    -1,    -1,   259,    -1,    -1,    -1,   144,   254,   171,
      -1,   148,   258,    -1,    -1,   177,   178,    -1,    -1,    -1,
     266,   158,    -1,   269,    -1,     4,   272,    -1,    -1,     8,
      -1,    -1,   278,    -1,   171,   281,    -1,    -1,    -1,    -1,
     177,   178,    -1,    -1,    -1,     4,    -1,    -1,    -1,     8,
      29,   213,    31,    -1,    -1,    34,    -1,    36,    37,    38,
      39,   223,     6,    -1,     8,    -1,    -1,    -1,    -1,    13,
      29,    50,    31,   235,   236,    34,   213,    36,    37,    38,
      39,    -1,    -1,    -1,    -1,    29,   223,    31,    -1,    -1,
      34,    50,    36,    37,    38,    39,   258,    -1,   235,   236,
      -1,    -1,    -1,    -1,   266,    -1,    50,   269,    -1,    -1,
     272,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   281,
      -1,   258,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   266,
      -1,    -1,   269,    -1,     3,   272,     5,     6,     7,     8,
      -1,    10,    -1,    12,   281,    -1,    -1,    16,    17,    -1,
      19,    20,    21,    22,    -1,    -1,    25,    26,    -1,    -1,
      29,    30,    -1,    -1,    -1,    34,    -1,    36,    37,    38,
      -1,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,     3,    -1,     5,     6,    -1,     8,    -1,    10,
      -1,    12,    -1,    -1,    -1,    16,    17,    -1,    19,    20,
      21,    22,    -1,    -1,    25,    26,    -1,    -1,    29,    30,
      -1,    -1,    -1,    34,    -1,    36,    37,    38,    -1,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
       3,    -1,     5,     6,    -1,     8,    -1,    10,    -1,    12,
      -1,    -1,    -1,    16,    17,    -1,    19,    20,    21,    22,
      -1,    -1,    25,    26,    -1,    -1,    29,    30,    -1,    -1,
      -1,    34,    -1,    36,    37,    38,    -1,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,     3,    -1,
       5,     6,    -1,     8,    -1,    10,    -1,    12,    -1,    -1,
      -1,    -1,    17,    -1,    -1,    -1,    -1,    22,    -1,    -1,
      25,    26,    -1,    -1,    29,    30,    -1,    -1,    -1,    34,
      -1,    36,    37,    38,    -1,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,     3,     4,     5,     6,
      -1,     8,    -1,    10,    -1,    12,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    22,    -1,    -1,    25,    26,
      -1,    -1,    29,    30,    -1,    -1,    -1,    34,    -1,    36,
      37,    38,    -1,    40,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,     3,    -1,     5,     6,    -1,     8,
       9,    10,    -1,    12,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    22,    -1,    -1,    25,    26,    -1,    -1,
      29,    30,    -1,    -1,    -1,    34,    -1,    36,    37,    38,
      -1,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,     3,    -1,     5,     6,    -1,     8,    -1,    10,
      11,    12,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    22,    -1,    -1,    25,    26,    -1,    -1,    29,    30,
      -1,    -1,    -1,    34,    -1,    36,    37,    38,    -1,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
       3,    -1,     5,     6,    -1,     8,    -1,    10,    -1,    12,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    22,
      -1,    -1,    25,    26,    -1,    -1,    29,    30,    -1,    -1,
      -1,    34,    -1,    36,    37,    38,    -1,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,     3,    -1,
       5,     6,    -1,     8,    -1,    10,    -1,    12,    -1,    -1,
      -1,    -1,    17,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,     3,    29,     5,     6,    32,     8,    34,
      10,    36,    12,    -1,    -1,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    -1,    -1,    -1,    -1,    29,
      -1,    31,    32,    -1,    34,     8,    36,    -1,    -1,    -1,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
       3,    -1,     5,     6,    -1,     8,    29,    10,    31,    12,
      -1,    34,    -1,    36,    37,    38,    39,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    29,    50,     8,    32,
      -1,    34,    -1,    36,    14,    -1,    -1,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    -1,    -1,    29,
      -1,    31,     8,    -1,    34,    -1,    36,    37,    38,    39,
      -1,    17,    -1,    -1,    -1,    -1,    -1,     8,     9,    -1,
      50,    -1,    -1,    29,    -1,    31,    -1,    -1,    34,    -1,
      36,    37,    38,    39,    -1,     8,    -1,    -1,    29,    -1,
      31,    14,    -1,    34,    50,    36,    37,    38,    39,    -1,
       8,    -1,    -1,    -1,    -1,    -1,    29,    -1,    31,    50,
      -1,    34,    -1,    36,    37,    38,    39,    -1,    -1,    -1,
      -1,    29,    -1,    31,    -1,    -1,    34,    50,    36,    37,
      38,    39,     0,    -1,    -1,    -1,     4,    -1,    -1,     7,
      -1,     9,    50,    -1,    -1,    -1,    -1,    15,    16,    17,
      -1,    19,    20,    21,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    35
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     5,     6,     8,    10,    12,    16,    17,    19,
      20,    21,    22,    25,    26,    29,    30,    34,    36,    37,
      38,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    52,    53,    54,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    67,    68,    69,    70,
      71,    72,    73,    74,    75,    76,    77,    78,    83,    84,
      85,    86,    87,    88,    89,    90,    92,    94,    95,    96,
      98,   103,   104,   105,   106,   107,   108,   109,   110,   111,
     112,   114,   115,   116,   117,   118,   123,    54,    55,    61,
      68,   113,    55,    55,    55,    55,    29,    34,    67,   119,
     120,   121,    61,    61,    68,   105,    58,    74,    27,    28,
      61,     0,    53,    57,    17,    53,    56,     8,    31,    39,
      64,    67,    90,    91,    96,     3,    32,    68,    97,   111,
      55,    97,    33,    15,    33,    65,     8,    64,    66,    67,
      68,    79,    80,     4,    61,    93,   113,    66,    61,    31,
       4,    15,    57,     7,    57,     9,   113,    11,    61,   122,
      12,    67,    15,    23,    99,   100,   101,    18,    58,    14,
      53,    61,    55,    31,    97,    93,    93,    61,    61,    97,
      55,    68,   113,     9,    67,    67,    58,     8,    64,    67,
      80,    58,    66,    79,    81,    82,   116,     4,    55,    97,
      55,    31,    55,    54,    55,    55,    55,    55,    15,    55,
      55,    67,    58,    61,    99,    24,    99,   102,    74,     6,
       9,    55,     4,    61,    67,    58,     9,    67,    58,    58,
      67,    55,   116,    97,     4,    61,    61,     7,     7,     9,
      13,    55,    11,    58,    13,    58,    58,    58,    55,    97,
      58,    67,    58,     3,    66,    81,     4,    55,    61,    67,
      35,   124,   125,    58,    55,    67,    61,    55,    58,    61,
      55,   125,    61,    13,    14,     7,    55,    55,    12,    57,
       4,    61,   119,    12,    57
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
   Once GCC version 2 has supplanted version 1, this can go.  However,
   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
   discussed.  */

#define YYFAIL		goto yyerrlab
#if defined YYFAIL
  /* This is here to suppress warnings from the GCC cpp's
     -Wunused-macros.  Normally we don't worry about that warning, but
     some users do, and we want to make it easy for users to remove
     YYFAIL uses, which will produce warnings from Bison 2.5.  */
#endif

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
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
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

/* Line 1464 of yacc.c  */
#line 161 "parser.y"
    {
                  rb_funcall(self, rb_intern("body:"), 1, (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 13:

/* Line 1464 of yacc.c  */
#line 183 "parser.y"
    {
                   (yyval.object) = rb_funcall(self, rb_intern("ast:exp_list:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 14:

/* Line 1464 of yacc.c  */
#line 186 "parser.y"
    {
                   (yyval.object) = rb_funcall(self, rb_intern("ast:exp_list:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 15:

/* Line 1464 of yacc.c  */
#line 189 "parser.y"
    {
                   (yyval.object) = (yyvsp[(2) - (2)].object);
                ;}
    break;

  case 16:

/* Line 1464 of yacc.c  */
#line 192 "parser.y"
    {
                   (yyval.object) = (yyvsp[(1) - (2)].object);
                ;}
    break;

  case 17:

/* Line 1464 of yacc.c  */
#line 197 "parser.y"
    {
                   (yyval.object) = (yyvsp[(3) - (5)].object);
                ;}
    break;

  case 18:

/* Line 1464 of yacc.c  */
#line 200 "parser.y"
    {
                   (yyval.object) = rb_funcall(self, rb_intern("ast:exp_list:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 19:

/* Line 1464 of yacc.c  */
#line 205 "parser.y"
    {
                   (yyval.object) = (yyvsp[(3) - (5)].object);
                ;}
    break;

  case 34:

/* Line 1464 of yacc.c  */
#line 226 "parser.y"
    { (yyval.object) = rb_funcall(self, rb_intern("ast:super_exp:"), 2, INT2NUM(yylineno), Qnil); ;}
    break;

  case 35:

/* Line 1464 of yacc.c  */
#line 227 "parser.y"
    { (yyval.object) = rb_funcall(self, rb_intern("ast:retry_exp:"), 2, INT2NUM(yylineno), Qnil); ;}
    break;

  case 36:

/* Line 1464 of yacc.c  */
#line 228 "parser.y"
    {
                  (yyval.object) = (yyvsp[(3) - (5)].object);
                ;}
    break;

  case 37:

/* Line 1464 of yacc.c  */
#line 231 "parser.y"
    {
                  (yyval.object) = (yyvsp[(1) - (3)].object);
                ;}
    break;

  case 38:

/* Line 1464 of yacc.c  */
#line 236 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:assign:to:"), 3, INT2NUM(yylineno), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object));
                ;}
    break;

  case 40:

/* Line 1464 of yacc.c  */
#line 242 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:assign:to:many:"), 4, INT2NUM(yylineno), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object), Qtrue);
                ;}
    break;

  case 41:

/* Line 1464 of yacc.c  */
#line 247 "parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:identifier:");
                ;}
    break;

  case 42:

/* Line 1464 of yacc.c  */
#line 252 "parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:identifier:");
                ;}
    break;

  case 43:

/* Line 1464 of yacc.c  */
#line 257 "parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:identifier:");
                ;}
    break;

  case 44:

/* Line 1464 of yacc.c  */
#line 261 "parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:identifier:");
                ;}
    break;

  case 45:

/* Line 1464 of yacc.c  */
#line 264 "parser.y"
    {
                  (yyval.object) = fy_terminal_node_from(self, "ast:identifier:", "match");
                ;}
    break;

  case 46:

/* Line 1464 of yacc.c  */
#line 267 "parser.y"
    {
                  (yyval.object) = fy_terminal_node_from(self, "ast:identifier:", "class");
                ;}
    break;

  case 49:

/* Line 1464 of yacc.c  */
#line 276 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 50:

/* Line 1464 of yacc.c  */
#line 279 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 51:

/* Line 1464 of yacc.c  */
#line 284 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:return_local_stmt:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 52:

/* Line 1464 of yacc.c  */
#line 287 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:return_local_stmt:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 53:

/* Line 1464 of yacc.c  */
#line 292 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:return_stmt:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 54:

/* Line 1464 of yacc.c  */
#line 295 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:return_stmt:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 55:

/* Line 1464 of yacc.c  */
#line 300 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:require_:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 56:

/* Line 1464 of yacc.c  */
#line 303 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:require_:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 59:

/* Line 1464 of yacc.c  */
#line 312 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:identity:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 60:

/* Line 1464 of yacc.c  */
#line 315 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:constant:parent:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 61:

/* Line 1464 of yacc.c  */
#line 320 "parser.y"
    { (yyval.object) = rb_intern("private"); ;}
    break;

  case 62:

/* Line 1464 of yacc.c  */
#line 321 "parser.y"
    { (yyval.object) = rb_intern("protected"); ;}
    break;

  case 63:

/* Line 1464 of yacc.c  */
#line 322 "parser.y"
    { (yyval.object) = rb_intern("public"); ;}
    break;

  case 64:

/* Line 1464 of yacc.c  */
#line 325 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:class:parent:body:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), Qnil, (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 65:

/* Line 1464 of yacc.c  */
#line 330 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:class:parent:body:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (5)].object), (yyvsp[(4) - (5)].object), (yyvsp[(5) - (5)].object));
                ;}
    break;

  case 72:

/* Line 1464 of yacc.c  */
#line 343 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:param:var:"), 3, INT2NUM(yylineno), (yyvsp[(1) - (2)].object), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 73:

/* Line 1464 of yacc.c  */
#line 348 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 74:

/* Line 1464 of yacc.c  */
#line 351 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 75:

/* Line 1464 of yacc.c  */
#line 354 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 76:

/* Line 1464 of yacc.c  */
#line 359 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:param:var:default:"), 4, INT2NUM(yylineno), (yyvsp[(1) - (7)].object), (yyvsp[(2) - (7)].object), (yyvsp[(5) - (7)].object));
                ;}
    break;

  case 77:

/* Line 1464 of yacc.c  */
#line 364 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 78:

/* Line 1464 of yacc.c  */
#line 367 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 79:

/* Line 1464 of yacc.c  */
#line 372 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:method:expand:access:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 80:

/* Line 1464 of yacc.c  */
#line 378 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:method:body:access:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 81:

/* Line 1464 of yacc.c  */
#line 384 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:method:expand:access:owner:"), 5, INT2NUM(yylineno), (yyvsp[(3) - (4)].object), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object), (yyvsp[(2) - (4)].object));
                ;}
    break;

  case 82:

/* Line 1464 of yacc.c  */
#line 389 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:method:body:access:owner:"), 5, INT2NUM(yylineno), (yyvsp[(3) - (4)].object), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object), (yyvsp[(2) - (4)].object));
                ;}
    break;

  case 83:

/* Line 1464 of yacc.c  */
#line 394 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:body:access:"), 5, INT2NUM(yylineno), (yyvsp[(2) - (4)].object), (yyvsp[(3) - (4)].object), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object));
                ;}
    break;

  case 84:

/* Line 1464 of yacc.c  */
#line 397 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:body:access:"), 5,
                                  INT2NUM(yylineno), fy_terminal_node_from(self, "ast:identifier:", "[]"), (yyvsp[(4) - (5)].object), (yyvsp[(5) - (5)].object), (yyvsp[(1) - (5)].object));
                ;}
    break;

  case 85:

/* Line 1464 of yacc.c  */
#line 403 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:body:access:owner:"), 6, INT2NUM(yylineno), (yyvsp[(3) - (5)].object), (yyvsp[(4) - (5)].object), (yyvsp[(5) - (5)].object), (yyvsp[(1) - (5)].object), (yyvsp[(2) - (5)].object));
                ;}
    break;

  case 86:

/* Line 1464 of yacc.c  */
#line 406 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:body:access:owner:"), 6,
                                  INT2NUM(yylineno), fy_terminal_node_from(self, "ast:identifier:", "[]"), (yyvsp[(5) - (6)].object), (yyvsp[(6) - (6)].object), (yyvsp[(1) - (6)].object), (yyvsp[(2) - (6)].object));
                ;}
    break;

  case 87:

/* Line 1464 of yacc.c  */
#line 412 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:to:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 88:

/* Line 1464 of yacc.c  */
#line 415 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:to:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 89:

/* Line 1464 of yacc.c  */
#line 418 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 90:

/* Line 1464 of yacc.c  */
#line 427 "parser.y"
    {
                  // remove the trailing left paren and create an identifier.
                  (yyval.object) = fy_terminal_node(self, "ast:ruby_send:");
                ;}
    break;

  case 91:

/* Line 1464 of yacc.c  */
#line 431 "parser.y"
    {
                  // remove the trailing left paren and create an identifier.
                  (yyval.object) = fy_terminal_node(self, "ast:ruby_send:");
                ;}
    break;

  case 92:

/* Line 1464 of yacc.c  */
#line 436 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:to:ruby:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(1) - (3)].object), (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 93:

/* Line 1464 of yacc.c  */
#line 439 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:to:ruby:"), 4, INT2NUM(yylineno), (yyvsp[(1) - (2)].object), Qnil, (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 94:

/* Line 1464 of yacc.c  */
#line 449 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ruby_args:block:"), 3, INT2NUM(yylineno), Qnil, (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 95:

/* Line 1464 of yacc.c  */
#line 452 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ruby_args:block:"), 3, INT2NUM(yylineno), (yyvsp[(1) - (3)].object), (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 96:

/* Line 1464 of yacc.c  */
#line 455 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ruby_args:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 97:

/* Line 1464 of yacc.c  */
#line 458 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ruby_args:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 98:

/* Line 1464 of yacc.c  */
#line 463 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:to:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 99:

/* Line 1464 of yacc.c  */
#line 466 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:to:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (5)].object), (yyvsp[(5) - (5)].object), (yyvsp[(1) - (5)].object));
                ;}
    break;

  case 100:

/* Line 1464 of yacc.c  */
#line 469 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:to:"), 4,
                                  INT2NUM(yylineno), fy_terminal_node_from(self, "ast:identifier:", "[]"), (yyvsp[(3) - (4)].object), (yyvsp[(1) - (4)].object));
                ;}
    break;

  case 101:

/* Line 1464 of yacc.c  */
#line 473 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:oper:arg:"), 3, INT2NUM(yylineno), (yyvsp[(1) - (2)].object), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 102:

/* Line 1464 of yacc.c  */
#line 478 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:to:ruby:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(1) - (3)].object), (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 103:

/* Line 1464 of yacc.c  */
#line 484 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:arg:"), 3, INT2NUM(yylineno), (yyvsp[(1) - (2)].object), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 104:

/* Line 1464 of yacc.c  */
#line 487 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:arg:"), 3, INT2NUM(yylineno), (yyvsp[(1) - (3)].object), (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 105:

/* Line 1464 of yacc.c  */
#line 490 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:arg:ary:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 106:

/* Line 1464 of yacc.c  */
#line 493 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:send:arg:ary:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (4)].object), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object));
                ;}
    break;

  case 107:

/* Line 1464 of yacc.c  */
#line 498 "parser.y"
    {
                  (yyval.object) = (yyvsp[(1) - (1)].object);
                ;}
    break;

  case 108:

/* Line 1464 of yacc.c  */
#line 501 "parser.y"
    {
                  (yyval.object) = (yyvsp[(2) - (3)].object);
                ;}
    break;

  case 109:

/* Line 1464 of yacc.c  */
#line 504 "parser.y"
    {
                  (yyval.object) = (yyvsp[(1) - (1)].object);
                ;}
    break;

  case 110:

/* Line 1464 of yacc.c  */
#line 507 "parser.y"
    {
                  (yyval.object) = (yyvsp[(2) - (2)].object);
                ;}
    break;

  case 111:

/* Line 1464 of yacc.c  */
#line 512 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:try_block:ex_handlers:finally_block:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (4)].object), (yyvsp[(3) - (4)].object), (yyvsp[(4) - (4)].object));
                ;}
    break;

  case 112:

/* Line 1464 of yacc.c  */
#line 515 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:try_block:ex_handlers:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (3)].object), (yyvsp[(3) - (3)].object));
                ;}
    break;

  case 113:

/* Line 1464 of yacc.c  */
#line 520 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ex_handler:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (2)].object));
                ;}
    break;

  case 114:

/* Line 1464 of yacc.c  */
#line 523 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ex_handler:cond:"), 3, INT2NUM(yylineno), (yyvsp[(3) - (3)].object), (yyvsp[(2) - (3)].object));
                ;}
    break;

  case 115:

/* Line 1464 of yacc.c  */
#line 526 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:ex_handler:cond:var:"), 4, INT2NUM(yylineno), (yyvsp[(5) - (5)].object), (yyvsp[(2) - (5)].object), (yyvsp[(4) - (5)].object));
                ;}
    break;

  case 116:

/* Line 1464 of yacc.c  */
#line 531 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 117:

/* Line 1464 of yacc.c  */
#line 534 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 118:

/* Line 1464 of yacc.c  */
#line 539 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 119:

/* Line 1464 of yacc.c  */
#line 542 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 120:

/* Line 1464 of yacc.c  */
#line 545 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 121:

/* Line 1464 of yacc.c  */
#line 550 "parser.y"
    {
                  (yyval.object) = (yyvsp[(2) - (2)].object);
                ;}
    break;

  case 122:

/* Line 1464 of yacc.c  */
#line 555 "parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:fixnum:");
                ;}
    break;

  case 123:

/* Line 1464 of yacc.c  */
#line 559 "parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:number:");
                ;}
    break;

  case 124:

/* Line 1464 of yacc.c  */
#line 563 "parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:string:");
                ;}
    break;

  case 125:

/* Line 1464 of yacc.c  */
#line 566 "parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:string:");
                ;}
    break;

  case 126:

/* Line 1464 of yacc.c  */
#line 570 "parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:symbol:");
                ;}
    break;

  case 127:

/* Line 1464 of yacc.c  */
#line 574 "parser.y"
    {
                  (yyval.object) = fy_terminal_node(self, "ast:regexp:");
                ;}
    break;

  case 128:

/* Line 1464 of yacc.c  */
#line 579 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:fixnum:base:"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(16));
                ;}
    break;

  case 129:

/* Line 1464 of yacc.c  */
#line 585 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:fixnum:base:"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(8));
                ;}
    break;

  case 130:

/* Line 1464 of yacc.c  */
#line 591 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:fixnum:base:"), 3,
                                  INT2NUM(yylineno), rb_str_new2(yytext), INT2NUM(2));
                ;}
    break;

  case 144:

/* Line 1464 of yacc.c  */
#line 612 "parser.y"
    {
                  (yyval.object) = (yyvsp[(1) - (1)].object);
                ;}
    break;

  case 145:

/* Line 1464 of yacc.c  */
#line 615 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:array:"), 2, INT2NUM(yylineno), (yyvsp[(3) - (5)].object));
                ;}
    break;

  case 146:

/* Line 1464 of yacc.c  */
#line 620 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 147:

/* Line 1464 of yacc.c  */
#line 623 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(4) - (4)].object), (yyvsp[(1) - (4)].object));
                ;}
    break;

  case 148:

/* Line 1464 of yacc.c  */
#line 626 "parser.y"
    {
                  (yyval.object) = (yyvsp[(1) - (2)].object);
                ;}
    break;

  case 149:

/* Line 1464 of yacc.c  */
#line 631 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:array:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 150:

/* Line 1464 of yacc.c  */
#line 636 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:hash:"), 2, INT2NUM(yylineno), (yyvsp[(3) - (5)].object));
                ;}
    break;

  case 151:

/* Line 1464 of yacc.c  */
#line 639 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:hash:"), 2, INT2NUM(yylineno), Qnil);
                ;}
    break;

  case 152:

/* Line 1464 of yacc.c  */
#line 644 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:partial_block:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 153:

/* Line 1464 of yacc.c  */
#line 647 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:block:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 154:

/* Line 1464 of yacc.c  */
#line 650 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:block:args:"), 3, INT2NUM(yylineno), (yyvsp[(5) - (5)].object), (yyvsp[(2) - (5)].object));
                ;}
    break;

  case 155:

/* Line 1464 of yacc.c  */
#line 655 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:tuple:"), 2, INT2NUM(yylineno), (yyvsp[(2) - (3)].object));
                ;}
    break;

  case 156:

/* Line 1464 of yacc.c  */
#line 660 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:range:to:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (6)].object), (yyvsp[(5) - (6)].object));
                ;}
    break;

  case 159:

/* Line 1464 of yacc.c  */
#line 669 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 160:

/* Line 1464 of yacc.c  */
#line 672 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 161:

/* Line 1464 of yacc.c  */
#line 677 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 162:

/* Line 1464 of yacc.c  */
#line 680 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(3) - (3)].object), (yyvsp[(1) - (3)].object));
                ;}
    break;

  case 163:

/* Line 1464 of yacc.c  */
#line 685 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:key:value:into:"), 4, INT2NUM(yylineno), (yyvsp[(1) - (5)].object), (yyvsp[(5) - (5)].object), Qnil);
                ;}
    break;

  case 164:

/* Line 1464 of yacc.c  */
#line 688 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:key:value:into:"), 4, INT2NUM(yylineno), (yyvsp[(4) - (8)].object), (yyvsp[(8) - (8)].object), (yyvsp[(1) - (8)].object));
                ;}
    break;

  case 165:

/* Line 1464 of yacc.c  */
#line 693 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:match_expr:body:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (8)].object), (yyvsp[(6) - (8)].object));
                ;}
    break;

  case 166:

/* Line 1464 of yacc.c  */
#line 698 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:"), 2, INT2NUM(yylineno), (yyvsp[(1) - (1)].object));
                ;}
    break;

  case 167:

/* Line 1464 of yacc.c  */
#line 701 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:concat:into:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (2)].object), (yyvsp[(1) - (2)].object));
                ;}
    break;

  case 168:

/* Line 1464 of yacc.c  */
#line 706 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:match_clause:body:"), 3, INT2NUM(yylineno), (yyvsp[(2) - (4)].object), (yyvsp[(4) - (4)].object));
                ;}
    break;

  case 169:

/* Line 1464 of yacc.c  */
#line 709 "parser.y"
    {
                  (yyval.object) = rb_funcall(self, rb_intern("ast:match_clause:body:args:"), 4, INT2NUM(yylineno), (yyvsp[(2) - (7)].object), (yyvsp[(7) - (7)].object), (yyvsp[(5) - (7)].object));
                ;}
    break;



/* Line 1464 of yacc.c  */
#line 2934 "parser.c"
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



/* Line 1684 of yacc.c  */
#line 714 "parser.y"



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


