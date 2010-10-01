#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.59])
AC_INIT([fancy], [1.0.0], [bugs@fancy-lang.org])
AM_INIT_AUTOMAKE([foreign])
AC_CONFIG_SRCDIR([src/array.cc])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CXX
AC_PROG_CC
AC_PROG_LEX
AC_PROG_MAKE_SET
AC_PROG_YACC
AX_PROG_BISON_VERSION([2.4],
		       [],
		       [AC_MSG_ERROR([Fancy needs bison version 2.4 or greater],[1])])

# Checks for libraries.
AC_CHECK_LIB([fl], [yyinput])

# Checks for header files.
AC_CHECK_HEADERS([unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_TYPE_SIZE_T

# Checks for library functions.
AC_FUNC_ERROR_AT_LINE
AC_CHECK_FUNCS([mkdir pow])

AC_CONFIG_FILES([Makefile
                 src/Makefile
                 src/bootstrap/Makefile
                 src/parser/Makefile
                 src/parser/nodes/Makefile])
AC_OUTPUT