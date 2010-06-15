#ifndef _PARSER_INCLUDES_H_
#define _PARSER_INCLUDES_H_

#include <cstdio>

#include "nodes/identifier.h"
#include "nodes/expression_list.h"
#include "nodes/array_literal.h"
#include "nodes/hash_literal.h"
#include "nodes/block_literal.h"
#include "nodes/class_definition.h"
#include "nodes/message_send.h"
#include "nodes/operator_send.h"
#include "nodes/assignment.h"
#include "nodes/return.h"
#include "nodes/require.h"
#include "nodes/method_definition.h"
#include "nodes/class_method_definition.h"
#include "nodes/operator_definition.h"
#include "nodes/class_operator_definition.h"
#include "nodes/try_catch_block.h"
#include "nodes/super.h"

#include "../number.h"
#include "../regexp.h"
#include "../string.h"
#include "../symbol.h"

#include "../bootstrap/core_classes.h"

#include "parser.h"


#define YY_NO_UNPUT

using namespace fancy;

#endif /* _PARSER_INCLUDES_H_ */
