#ifndef _FANCY_EXCEPTION_H_
#define _FANCY_EXCEPTION_H_

namespace fancy {

  /**
   * Class that represents Exceptions within Fancy.
   */
  class FancyException : public FancyObject
  {
  public:
    /**
     * Initializes an Exception of a given Exception Class.
     * @param Exception_class The (runtime) Class of the Exception.
     */
    FancyException(Class_p Exception_class);

    /**
     * Initializes an Exception with a given message and an Exception Class.
     * @param message Message of the Exception.
     * @param Exception_class The (runtime) Class of the Exception.
     */
    FancyException(const string &message, Class_p Exception_class);

    /**
     * Initializes an Exception with a given message.
     * Its runtime Class will be ExceptionClass.
     * @param message Message of the Exception.
     */
    FancyException(const string &message);

    /**
     * Initializes an Exception with a given exception_value and a message.
     * @param exception_value Value representing the Exception.
     * @param message Message of the Exception.
     */
    FancyException(FancyObject_p exception_value, const string &message);

    virtual ~FancyException();

    virtual FancyObject_p equal(const FancyObject_p other) const;
    virtual EXP_TYPE type() const;
    virtual string to_s() const;

    /**
     * Returns the message of the Exception.
     * @return Message of the Exception (can be an empty String if not defined).
     */
    string message() const;

    /**
     * Returns the (runtime) Class of the Exception.
     * E.g. MethodNotFoundError, IOError etc.
     * @return (Runtime) Class of the Exception.
     */
    Class_p exception_class() const;

    /**
     * Returns the Exception's value.
     * @return The Exception's value or 'this' (if not set).
     */
    FancyObject_p exception_value();

  private:
    FancyObject_p _exception_value;
    Class_p _exception_class;
    string _message;
  };

  typedef FancyException* FancyException_p;

}

#endif /* _FANCY_EXCEPTION_H_ */
