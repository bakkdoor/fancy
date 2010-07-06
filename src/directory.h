#ifndef _DIRECTORY_H_
#define _DIRECTORY_H_

#include <string>

#include "fancy_object.h"

using namespace std;

namespace fancy {

  class Directory : public FancyObject
  {
  public:
    Directory(const string &dirname);
    virtual ~Directory();

    /**
     * See FancyObject for these methods.
     */
    virtual FancyObject* equal(FancyObject* other) const;
    virtual EXP_TYPE type() const { return EXP_DIRECTORY; }
    virtual string to_s() const;

    /**
     * Returns the dirname set for this Directory object.
     * @return The dirname set for this Directory object.
     */
    string dirname() const { return _dirname; }

  private:
    string _dirname;

  };

}

#endif /* _DIRECTORY_H_ */
