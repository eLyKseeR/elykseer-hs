#ifndef _LXR_KEY128
#define _LXR_KEY128

#include "FFI.h"

#ifdef __cplusplus
extern "C" {
#endif

MT_API HsPtr key128_random();
MT_API HsPtr key128_fromhex(char const *);
MT_API void key128_release(HsPtr ptr);
MT_API int key128_length(HsPtr ptr);
MT_API char const * key128_tohex(HsPtr ptr);

#ifdef __cplusplus
}
#endif

#endif //_LXR_KEY128
