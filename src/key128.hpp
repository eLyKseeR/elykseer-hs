#ifndef _LXR_KEY128
#define _LXR_KEY128

#include "FFI.h"

#ifdef __cplusplus
extern "C" {
#endif

HS_API HsPtr key128_random();
HS_API HsPtr key128_fromhex(char const *, int);
HS_API void key128_release(HsPtr ptr);
HS_API int key128_length(HsPtr ptr);
HS_API char const * key128_tohex(HsPtr ptr);

#ifdef __cplusplus
}
#endif

#endif //_LXR_KEY128
