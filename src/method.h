#ifndef _FUNCTION_H_
#define _FUNCTION_H_

#include "fancy_object.h"
#include "callable.h"
#include "scope.h"
#include "parser/nodes/identifier.h"
#include "parser/nodes/expression_list.h"

using namespace fancy::parser::nodes;

namespace fancy {

  struct method_arg_node {
  public:
    Identifier* name;
    Identifier* identifier;
    method_arg_node *next;
  };

  /**
   * Method class representing Method (objects) in Fancy.
   */
  class Method : public FancyObject, public Callable
  {
  public:
    /**
     * Method constructor for Operator methods.
     * @param op_name Identifier of the operator name (e.g. '+', '-', '=~', etc.).
     * @param op_argname Identifier of the argument name for the
     * operator method (used in the body of the method)
     * @param body ExpressionList that is the methods body.
     */
    Method(Identifier* op_name, Identifier* op_argname, ExpressionList* body);

    /**
     * Method constructor for 'normal' methods.
     * @param argnames List of pairs of Identifiers for each argument
     * key and variable name (used in the methods body).
     * @param body ExpressionList that is the methods body.
     */
    Method(const list< pair<Identifier*, Identifier*> > argnames, ExpressionList* body);

    /**
     * Empty Method constructor. Used by subclasses (e.g. NativeMethod).
     */
    Method();

    ~Method();

    /**
     * See FancyObject for these methods.
     */
    virtual EXP_TYPE type() const;
    virtual string to_s() const;
    virtual string to_sexp() const;

    /**
     * Inherited from Callable. Calls the method.
     * @param self The self object, also known as the receiver of the method.
     * @param args C++ Array of FancyObjects that are the arguments for this method.
     * @param args Amount of arguments passed to this method.
     * @param scope Scope in which the method should be evaluated.
     * @return Return value of the method call.
     */
    virtual FancyObject* call(FancyObject* self, FancyObject* *args, int argc, Scope *scope);

    /**
     * Inherited from Callable. Calls the method with no arguments.
     * @param self The self object, also known as the receiver of the method.
     * @param scope Scope in which the method should be evaluated.
     * @return Return value of the method call.
     */
    virtual FancyObject* call(FancyObject* self, Scope *scope);

    /**
     * Returns the amount of arguments this method expects.
     * @return The amount of arguments this method expects.
     */
    unsigned int argcount() const;

    /**
     * Returns a list of pairs of Identifiers holding the argument key
     * and variable name for the body of the method.
     * @return List of pairs of Identifiers with argument key and
     * variable name.
     */
    list< pair<Identifier*, Identifier*> > argnames() const;

    /**
     * Returns the name of the Method.
     * @return Name of the Method.
     */
    string name() const;

    /**
     * Sets the name of a Method.
     * @param method_name Name of the Method.
     */
    void set_name(const string &method_name);

  protected:
    void init_method_ident();
    void init_docstring();
    list< pair<Identifier*, Identifier*> > _argnames;
    ExpressionList* _body;
    bool _is_operator;
    string _method_ident;
  };

}

#endif /* _FUNCTION_H_ */
