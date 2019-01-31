#ifndef _LXR_OPTIONS
#define _LXR_OPTIONS

#include "FFI.h"

#ifdef __cplusplus
extern "C" {
#endif

HS_API HsPtr options_new();
HS_API int options_get_nchunks(HsPtr);
HS_API void options_set_nchunks(HsPtr, int);
HS_API int options_get_nredund(HsPtr);
HS_API void options_set_nredund(HsPtr, int);
HS_API int options_get_iscompr(HsPtr);
HS_API void options_set_iscompr(HsPtr, int);
HS_API int options_get_isdedup(HsPtr);
HS_API void options_set_isdedup(HsPtr, int);
HS_API char const * options_get_fpchunks(HsPtr);
HS_API void options_set_fpchunks(HsPtr, char const *);
HS_API char const * options_get_fpmeta(HsPtr);
HS_API void options_set_fpmeta(HsPtr, char const *);

#ifdef __cplusplus
}
#endif

#endif //_LXR_OPTIONS
