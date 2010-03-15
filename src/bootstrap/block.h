#ifndef _BOOTSTRAP_BLOCK_H_
#define _BOOTSTRAP_BLOCK_H_

void init_block_class();

/**
 * Block instance methods
 */
FancyObject_p method_Block_call(FancyObject_p self, list<Expression_p> args, Scope *scope);
FancyObject_p method_Block_call_with_arg(FancyObject_p self, list<Expression_p> args, Scope *scope);
FancyObject_p method_Block_while_true(FancyObject_p self, list<Expression_p> args, Scope *scope);

#endif /* _BOOTSTRAP_BLOCK_H_ */
