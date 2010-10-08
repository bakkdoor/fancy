grammar Fancy;

options {
    language = Ruby;
}

program returns [ node ]
    :{node = [:exp_list]} (
    |   val=code { node << val } (DELIM val=code { node << val })* )
    ;

code returns [ node ]
@after { node = val }
    :   val=statement //{ node = val }
    |   val=expression  //{ node = val }
    ;

statement returns [ node ]
    :   val=assignment { node = val }
    ;

assignment returns [ node ]
@init { node = [:assign] }
    :   id=identifier SPACE '=' SPACE exp=expression { node << id; node << exp }
    ;

expression returns [ node ]
options {
    backtrack = true;
}
@after { node = val }
    :   val=message_send
    |   val=operator_send
    |   val=literal_value
    |   val=identifier
    |   '(' val=expression ')'
    ;

message_send returns [ node ]
options {
    backtrack = true;
}
    :   { node = [:message_send] }
        rcv=receiver SPACE msg=message  { node << rcv; node << msg[0]; node << msg[1] }
        (SPACE msg=message {node = [:message_send, node, msg[0], msg[1]] })*
    ;

operator_send returns [ node ]
    @init{ node=[:message_send] }
    :   rcv=receiver SPACE op=OPERATOR SPACE arg=arg_exp
        { node << rcv; node << [:ident, op.text]; node << [:message_args, arg] }
    ;

receiver returns [ node ]
    @after{ node = val }
    :   '(' SPACE? val=expression SPACE? ')'
    |   val=identifier
    |   val=literal_value
    |   'super'                 { val = [:super] }
    ;

message returns [ node ]
    :   id=identifier { node = [id, [:message_args]] }
    ;

arg_exp returns [ node ]
    @after{ node = val }
    :   val=identifier
    |   '(' SPACE? val=expression SPACE? ')'
    |   val=literal_value
    ;

literal_value returns [ node ]
    @after{ node = lit }
    :   lit=int_lit
    |   lit=double_lit
    |   lit=string_lit
    |	lit=regexp_lit
    |	lit=symbol_lit
    ;

/****************** literals *****************/

int_lit returns [ node ]
    : INT_LIT_TOKEN  { node = [:int_lit, $INT_LIT_TOKEN.text.gsub(/_/, "")] }
    ;

double_lit returns [ node ]
    : 	DOUBLE_LIT_TOKEN { node = [:double_lit, $DOUBLE_LIT_TOKEN.text.gsub(/_/, "")] }
    ;

string_lit returns [ node ]
    : 	STRING_LIT_TOKEN { node = [:string_lit, $STRING_LIT_TOKEN.text] }
    ;

regexp_lit returns [ node ]
	:	REGEXP_LIT_TOKEN { node = [:regexp_lit, $REGEXP_LIT_TOKEN.text] }
	;

symbol_lit returns [ node ]
	: 	SYMBOL_LIT_TOKEN { node = [:symbol_lit, ":" + $SYMBOL_LIT_TOKEN.text[1..-1]] }
	;

/****************** identifier ***************/
identifier returns [ node ]
    :  val=(ID | MEMBER | CLASS_MEMBER) { node = [:ident, $val.text] }
    ;

/****************** tokens *******************/
INT_LIT_TOKEN
	: '-'? (DIGIT | '_')+
	;

DOUBLE_LIT_TOKEN
	: INT_LIT_TOKEN '.' DIGIT+
	;

STRING_LIT_TOKEN
	: '"' ~('"' | '\n')* '"'
	;

REGEXP_LIT_TOKEN
	: 'r{' .* '}'
	;

OPERATOR
	:	SPECIAL+ | ('||' SPECIAL*)
	;

ID
	: (LETTER | DIGIT | SPECIAL)+
	;

MEMBER
	: '@' ID
	;

CLASS_MEMBER
	: '@@' ID
	;

SPACE
    : ' ' | '\t'
    ;

DELIM
	: (('\r'? '\n')+ | ';') { $channel = HIDDEN; }
	;

COMMENT
	: '#' .* ('\r'? '\n') {$channel = HIDDEN;}
	;

WS
	: (' '|'\r'|'\t'|'\u000C'|'\n') { $channel = HIDDEN; }
	;

SYMBOL_LIT_TOKEN
	:	'\'' (ID | MEMBER | CLASS_MEMBER | OPERATOR | ':' | '[]')+
	;

/***************** fragments ****************/
fragment SPECIAL
	: ('-' | '+' | '?' | '!' | '_' | '=' | '*' | '/' | '^' | '>' | '<' | '%' | '&')
	;

fragment DIGIT
	: '0'..'9'
	;

fragment LETTER
	: 'A'..'Z' | 'a'..'z'
	;

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




