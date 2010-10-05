grammar Fancy;

options {
    language = Java;
    output = AST;
}

tokens {
    PROGRAM;
    IDENT;
    INT_LIT;
    DOUBLE_LIT;
    STRING_LIT;
    SYMBOL_LIT;
    REGEXP_LIT;
}

program
    :
    |   code+ (DELIM code)* ->^(PROGRAM code+)
    ;

code
    :   statement
    |   expression
    ;

statement
    :   assignment
    ;

assignment
    :   identifier '='^ expression
    ;

expression
    :   literal_value
    |   identifier
    |   '('! expression ')'!
    ;

literal_value
    :   int_lit
    |   double_lit
    |   string_lit
    |	regexp_lit
    |	symbol_lit
    ;

/****************** literals *****************/

int_lit
    : INT_LIT_TOKEN ->^(INT_LIT INT_LIT_TOKEN)
    ;

INT_LIT_TOKEN: '-'? (DIGIT | '_')+  ;

double_lit
    : 	DOUBLE_LIT_TOKEN ->^(DOUBLE_LIT DOUBLE_LIT_TOKEN)
    ;

DOUBLE_LIT_TOKEN: INT_LIT_TOKEN '.' DIGIT+ ;

string_lit
    : 	STRING_LIT_TOKEN ->^(STRING_LIT STRING_LIT_TOKEN)
    ;

STRING_LIT_TOKEN : '"' ~('"' | '\n')* '"';

regexp_lit
	:	REGEXP_LIT_TOKEN ->^(REGEXP_LIT REGEXP_LIT_TOKEN)
	;
	
REGEXP_LIT_TOKEN: 'r{' .* '}';

symbol_lit
	: 	SYMBOL_LIT_TOKEN ->^(SYMBOL_LIT SYMBOL_LIT_TOKEN)
	;
	
/****************** identifier ***************/
identifier
    :  (ID | MEMBER | CLASS_MEMBER) ->^(IDENT ID? MEMBER? CLASS_MEMBER?)
    ;

/****************** tokens *******************/
ID
	: (LETTER | DIGIT | SPECIAL)+;
MEMBER
	: '@' ID;
CLASS_MEMBER
	: '@@' ID;
OPERATOR
	:	SPECIAL+ | ('||' SPECIAL*);
DELIM
	: (('\r'? '\n')+ | ';') { $channel = HIDDEN; };
COMMENT
	: '#' .* ('\r'? '\n') {$channel = HIDDEN;};
WS	
	: (' '|'\r'|'\t'|'\u000C'|'\n') { $channel = HIDDEN; };
SYMBOL_LIT_TOKEN
	:	'\'' (ID | MEMBER | CLASS_MEMBER | OPERATOR | ':' | '[]')+ ;
	
/***************** fragments ****************/
fragment SPECIAL: ('-' | '+' | '?' | '!' | '_' | '=' | '*' | '/' | '^' | '>' | '<' | '%' | '&');
fragment DIGIT: '0'..'9';
fragment LETTER: 'A'..'Z' | 'a'..'z';

// code
//     : statement
//     | exp
//     ;

// statement
//     : assignment
//     ;

// assignment
//     : IDENTIFIER '=' exp
//     ;

// exp
//     : literal_value
//     | IDENTIFIER
//     | '(' exp ')'
//     ;

// literal_value
//     : int_lit
//     | double_lit
//     ;

// int_lit
//     : '-'? (DIGIT | '_')+
//     ;

// double_lit
//     : int_lit '.' DIGIT+
//     ;

/* ***************** TOKENS ***********************/

// SPECIAL          : ('-' | '+' | '?' | '!' | '_' | '=' | '*' | '/' | '^' | '>' | '<' | '%' | '&') ;
// OPERATOR         : SPECIAL+ | ('||' SPECIAL*);
// //INT_LIT          : '-'? (DIGIT | '_')+ ;
// //DOUBLE_LIT       : INT_LIT '.' DIGIT+ ;
// STRING_LIT       : '"' ~('"' | '\n')* '"';
// DOC_STRING       : '"""' ~('"')* '"""';
// DELIMITER        : ' ' | '\n' | '\r' | '\t' | '(' | ')';
// RETURN_LOCAL     : 'return_local';
// RETURN           : 'return';
// REQUIRE          : 'require:';
// TRY              : 'try';
// CATCH            : 'catch';
// FINALLY          : 'finally';
// RETRY            : 'retry';
// SUPER            : 'super';
// PRIVATE          : 'private';
// PROTECTED        : 'protected';
// RB_ARGS_PREFIX   : '~';
// SELF             : 'self';
// DEF_CLASS        : 'def' 'class';
// DEF              : 'def';

// NESTED_IDENTIFIER: ( LETTER CHAR+ '::')+ LETTER CHAR+;
//
// REGEXP_LIT       : 'r{' .* '}';
// COMMENT          : '#' .* NL {$channel = HIDDEN;};
// NL               : '\r'? '\n';

// fragment CHAR             : LETTER | DIGIT | SPECIAL;
// fragment ARROW            : '=>';
// fragment EQUALS           : '=';
// fragment COMMA            : ',';
// fragment SEMI             : ';';
// fragment COLON            : ':';
// fragment DOT              : '.';
// fragment DOLLAR           : '$';
// fragment LPAREN           : '(';
// fragment RPAREN           : ')';
// fragment LCURLY           : '{';
// fragment RCURLY           : '}';
// fragment LBRACKET         : '[';
// fragment RBRACKET         : ']';
// fragment LHASH            : '<[';
// fragment RHASH            : ']>';
// fragment STAB             : '|';




