#ifndef _FANCY_EXCEPTION_H_
#define _FANCY_EXCEPTION_H_

#include <string>

#include "fancy_object.h"
#include "class.h"

using namespace std;

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
    FancyException(Class* Exception_class);

    /**
     * Initializes an Exception with a given message and an Exception Class.
     * @param message Message of the Exception.
     * @param Exception_class The (runtime) Class of the Exception.
     */
    FancyException(const string &message, Class* Exception_class);

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
    FancyException(FancyObject* exception_value, const string &message);

    virtual ~FancyException();

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
    Class* exception_class() const;

    /**
     * Returns the Exception's value.
     * @return The Exception's value or 'this' (if not set).
     */
    FancyObject* exception_value();

  private:
    FancyObject* _exception_value;
    Class* _exception_class;
    string _message;
  };

}

#endif /* _FANCY_EXCEPTION_H_ */
