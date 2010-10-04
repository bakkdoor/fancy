grammar Fancy;

options {
    target = Java;
    output = AST;
}

/* ***************** TOKENS ***********************/
DIGIT            : '0-9';
LETTER           : 'A-Z' | 'a-z';
SPECIAL          : '-' | '+' | '?' | '!' | '_' | '=' | '*' | '/' | '^' | '>' | '<' | '%' | '&' ;
OPERATOR         : SPECIAL+ | ("||" SPECIAL*)
INT_LIT          : '-'? (DIGIT | '_')+ ;
DOUBLE_LIT       : INT_LIT '.' DIGIT+ ;
STRING_LIT       : '"' ~('"' | '\n')* '"';
DOC_STRING       : '"""' ~('"')* '"""';
LPAREN           : '(';
RPAREN           : ')';
LCURLY           : '{';
RCURLY           : '}';
LBRACKET         : '[';
RBRACKET         : ']';
LHASH            : '<[';
RHASH            : ']>';
STAB             : '|';
ARROW            : '=>';
DELIMITER        : ' ' | '\n' | '\r' | '\t' | '(' | ')';
RETURN_LOCAL     : 'return_local';
RETURN           : 'return';
REQUIRE          : 'require:';
TRY              : 'try';
CATCH            : 'catch';
FINALLY          : 'finally';
RETRY            : 'retry';
SUPER            : 'super';
PRIVATE          : 'private';
PROTECTED        : 'protected';
RB_ARGS_PREFIX   : "~";
SELF             : 'self';
IDENTIFIER       : '@'? '@'? ( CHAR )+;
NESTED_IDENTIFIER: ( LETTER CHAR+ '::')+ LETTER CHAR+;
SYMBOL_LIT       : "'" ( IDENTIFIER | OPERATOR | ':' | '[]')+;
REGEXP_LIT       : 'r{' .* '}';
COMMA            : ',';
SEMI             : ';';
EQUALS           : '=';
COLON            : ':';
DEF_CLASS        : 'def' (' ' | '\t')+ 'class';
DEF              : 'def';
DOT              : '.';
DOLLAR           : '$';
COMMENT          : '#' ~('\r'? '\n')+ {$channel = HIDDEN;};

WS               : (' '|'\r'|'\t'|'\u000C'|'\n') {$channel=HIDDEN;}

/* ********************** FRAGMENTS ****************/
/* Fragments are just shorter terms for use within
   the grammar, there are no tokens generated from
   them */
fragment
CHAR             : LETTER | DIGIT | SPECIAL;

