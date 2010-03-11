#ifndef _BOOTSTRAP_STRING_H_
#define _BOOTSTRAP_STRING_H_

void init_string_class();

/**
 * String instance methods
 */
FancyObject_p method_String_downcase(list<Expression_p> args, Scope *scope);
FancyObject_p method_String_upcase(list<Expression_p> args, Scope *scope);


#endif /* _BOOTSTRAP_STRING_H_ */
