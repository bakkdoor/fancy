#ifndef _EXPRESSION_LIST_H_
#define _EXPRESSION_LIST_H_

namespace fancy {

  /**
   * Linked list node for ExpressionLists.
   * Used in the parser.
   */
  struct expression_node {
    Expression_p     expression;
    expression_node *next;
  };

  /**
   * Class representing a list of Expressions.
   * Gets used (for example) for the body of class or method
   * definitions, as well as Block-bodies.
   */
  class ExpressionList : public Expression
  {
  public:
    /**
     * Initializes an ExpressionList with a list of Expressions.
     * @param expressions List of Expressions.
     */
    ExpressionList(list<Expression_p> expressions);

    /**
     * Initializes an ExpressionList with a expression_node
     * linked-list of Expressions.
     */
    ExpressionList(expression_node *list);
    ~ExpressionList();

    /**
     * Evaluates each Expression in the ExpressionList.
     * @param scope The scope in which to evaluate the ExpressionList.
     * @return The value of the last evaluated Expression in the
     * ExpressionList.
     */  
    virtual FancyObject_p eval(Scope *scope);
    virtual OBJ_TYPE type() const;

    /**
     * Returns the size (amount of top-level Expressions) in the
     * ExpressionList.
     * @return Amount of top-level Expressions in the ExpressionList.
     */
    unsigned int size() const;

    /**
     * If the first Expression in an ExpressionList is a
     * StringLiteral, returns the value of that String.
     * Usually, that StringLiteral represents the docstring (for
     * e.g. Class or Method definitions).
     * @return The DocString of the ExpressionList or the empty String, if none defined.
     */
    string docstring() const;

  private:
    list<Expression_p> _expressions;
  };

  typedef ExpressionList* ExpressionList_p;

}

#endif /* _EXPRESSION_LIST_H_ */
