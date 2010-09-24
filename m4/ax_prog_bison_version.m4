#   Makes sure that bison supports the version indicated. If true the shell
#   commands in ACTION-IF-TRUE are executed. If not the shell commands in
#   ACTION-IF-FALSE are run. Note that $YACC must be set previouly since
#	this macro relies on it, the AC_PROG_YACC macro should be prepended
#	to AX_PROG_BISON_VERSION in order to set $YACC.
#
#   Example:
#
#     AC_PROG_YACC
#     AX_PROG_BISON_VERSION([2.4],[ ... ],[ ... ])
#
#   This will check to make sure that the bison you have supports at least
#   version 2.4.
#
#   NOTE: This macro uses the $YACC variable to perform the check.
#   AX_WITH_BISON can be used to set that variable prior to running this
#   macro. The $BISON_VERSION variable will be valorized with the detected
#   version.
#
# LICENSE
#
#   Copyright (c) 2010 Jose Narvaez <goyox86@gmail.com>
#
#   This program is free software; you can redistribute it and/or modify it
#   under the terms of the GNU General Public License as published by the
#   Free Software Foundation; either version 2 of the License, or (at your
#   option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
#   Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program. If not, see <http://www.gnu.org/licenses/>.
#

AC_DEFUN([AX_PROG_BISON_VERSION],[
    AC_REQUIRE([AC_PROG_SED])
    AC_REQUIRE([AC_PROG_GREP])

    AS_IF([test -n "$YACC"],[
        ax_bison_version="$1"
		AC_MSG_CHECKING([for bison version])
        changequote(<<,>>)
        bison_version=`$YACC --version 2>&1 | $GREP "bison (GNU Bison) " | $SED -e 's/.* \([0-9]*\.[0-9]*\.[0-9]*\)/\1/'`
        changequote([,])
        AC_MSG_RESULT($bison_version)

	AC_SUBST([BISON_VERSION],[$ax_bison_version])

        AX_COMPARE_VERSION([$ax_bison_version],[le],[$bison_version],[
	    :
            $2
        ],[
	    :
            $3
        ])
    ],[
        AC_MSG_WARN([could not find bison])
        $3
    ])
])
