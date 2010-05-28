#ifndef _BLOCK_H_
#define _BLOCK_H_

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
    Block(ExpressionList_p body, Scope *creation_scope);

    /**
     * Initializes Block with a list of argument names, a body and the
     * scope in which it was created.
     * @param argnames List of argument names
     * @param body Body of the block (code).
     * @param creation_scope Scope in which Block was created (used
     * for closures).
     */
    Block(list<Identifier_p> argnames, ExpressionList_p body, Scope *creation_scope);

    virtual ~Block();

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual EXP_TYPE type() const;
    virtual string to_s() const;

    /**
     * Calls the Block (see Callable).
     * @return Return value from calling the Block.
     */
    FancyObject_p call(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope);

    /**
     * Calls the Block with no arguments (see Callable).
     * @return Return value from calling the Block.
     */
    FancyObject_p call(FancyObject_p self, Scope *scope);

    /**
     * Sets the creation_scope of the Block.
     * @param creation_scope The creation_scope of the Block.
     */
    void set_creation_scope(Scope *creation_scope);

    /**
     * Return the creation_scope of the Block.
     * @return The creation_scope of the Block.
     */
    Scope* creation_scope() const;

    /**
     * Returns vector of String objects of the argument names.
     * @return Vector of String objects of the argument names.
     */
    vector<FancyObject_p> args();

    /**
     * Returns the amount of arguments for the Block.
     * @return Amount of arguments the Block expects.
     */
    unsigned int argcount() const;

    /**
     * Sets the override_self flag, that indicates if the block should
     * override the current_self value before calling its body.

     * This is needed in some special cases like:
     * Class##define_method:with:

     * @param do_it Boolean value that indicates, if override_self
     * should be set or not.
     */
    void override_self(bool do_it);

    /**
     * Indicates, if the body of the block is empty.
     * @return true if the body's block is empty.
     */
    bool is_empty() const;

  private:
    void init_orig_block_arg_values();

    list<Identifier_p> _argnames;
    ExpressionList_p _body;
    Scope *_creation_scope;
    bool _override_self;
    int _argcount;
    list<FancyObject_p> _block_arg_orig_values;
  };

  typedef Block* Block_p;

}

#endif /* _BLOCK_H_ */
