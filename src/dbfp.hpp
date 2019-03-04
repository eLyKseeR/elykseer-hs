#ifndef _LXR_DBFP
#define _LXR_DBFP

#include "FFI.h"

#ifdef __cplusplus
extern "C" {
#endif

HS_API int dbfp_count(HsPtr);
HS_API bool dbfp_contains(HsPtr, char const *);

HS_API void dbfp_instream(HsPtr, char const *);
HS_API void dbfp_outstream(HsPtr, char const *);

#ifdef __cplusplus
}
#endif

#endif //_LXR_DBFP
