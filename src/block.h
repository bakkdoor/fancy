#ifndef _BLOCK_H_
#define _BLOCK_H_

#include <list>
#include <vector>

#include "fancy_object.h"
#include "scope.h"
#include "callable.h"
#include "parser/nodes/identifier.h"
#include "parser/nodes/expression_list.h"

using namespace std;
using namespace fancy::parser::nodes;

namespace fancy {

  /**
   * Block class.
   * A block is (as in Ruby or Smalltalk) an object (instance of
   * BlockClass) that represents an anonymous method / a closure.
   */
  class Block : public FancyObject, public Callable
  {
  public:
    /**
     * Initializes Block with a given body and the scope in which it
     * was created.
     * @param body Body of the block (code).
     * @param creation_scope Scope in which Block was created (used
     * for closures).
     */
    Block(parser::nodes::ExpressionList* body, Scope *creation_scope);

    /**
     * Initializes Block with a list of argument names, a body and the
     * scope in which it was created.
     * @param argnames List of argument names
     * @param body Body of the block (code).
     * @param creation_scope Scope in which Block was created (used
     * for closures).
     */
    Block(list<parser::nodes::Identifier*> argnames, parser::nodes::ExpressionList* body, Scope *creation_scope);

    virtual ~Block();

    virtual EXP_TYPE type() const { return EXP_BLOCK; }
    virtual string to_s() const;

    /**
     * Calls the Block (see Callable).
     * @return Return value from calling the Block.
     */
    FancyObject* call(FancyObject* self, FancyObject* *args, int argc, Scope *scope, FancyObject* sender);

    /**
     * Calls the Block with no arguments (see Callable).
     * @return Return value from calling the Block.
     */
    FancyObject* call(FancyObject* self, Scope *scope, FancyObject* sender);

    /**
     * Sets the creation_scope of the Block.
     * @param creation_scope The creation_scope of the Block.
     */
    void set_creation_scope(Scope *creation_scope) { _creation_scope = creation_scope; }

    /**
     * Return the creation_scope of the Block.
     * @return The creation_scope of the Block.
     */
    Scope* creation_scope() const { return _creation_scope; }

    /**
     * Returns vector of String objects of the argument names.
     * @return Vector of String objects of the argument names.
     */
    vector<FancyObject*> args();

    /**
     * Returns the amount of arguments for the Block.
     * @return Amount of arguments the Block expects.
     */
    unsigned int argcount() const { return _argcount; }

    /**
     * Sets the override_self flag, that indicates if the block should
     * override the current_self value before calling its body.

     * This is needed in some special cases like:
     * Class##define_method:with:

     * @param do_it Boolean value that indicates, if override_self
     * should be set or not.
     */
    void override_self(bool do_it) { _override_self = do_it; }

    /**
     * Indicates, if the body of the block is empty.
     * @return true if the body's block is empty.
     */
    bool is_empty() const { return _body->size() == 0; }

    parser::nodes::ExpressionList* body() const { return _body; }

  private:
    void init_orig_block_arg_values();

    list<parser::nodes::Identifier*> _argnames;
    parser::nodes::ExpressionList* _body;
    Scope *_creation_scope;
    bool _override_self;
    int _argcount;
    map<string, FancyObject*> _block_arg_orig_values;
  };

}

#endif /* _BLOCK_H_ */
