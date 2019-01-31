#ifndef _LXR_KEY256
#define _LXR_KEY256

#include "FFI.h"

#ifdef __cplusplus
extern "C" {
#endif

HS_API HsPtr key256_random();
HS_API HsPtr key256_fromhex(char const *);
HS_API void key256_release(HsPtr ptr);
HS_API int key256_length(HsPtr ptr);
HS_API char const * key256_tohex(HsPtr ptr);

#ifdef __cplusplus
}
#endif

#endif //_LXR_KEY256
