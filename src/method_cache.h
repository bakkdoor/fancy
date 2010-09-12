#ifndef _METHOD_CACHE_H_
#define _METHOD_CACHE_H_

namespace fancy {
  class MethodCache
  {
  public:
    virtual void invalidate_cache() = 0;
  };
}

#endif /* _METHOD_CACHE_H_ */
