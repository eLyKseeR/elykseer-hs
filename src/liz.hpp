#ifndef _LXR_LIZ
#define _LXR_LIZ

#include "FFI.h"

#ifdef __cplusplus
extern "C" {
#endif

HS_API char liz_verify();
HS_API int liz_daysleft();

HS_API char const * liz_name();
HS_API char const * liz_version();
HS_API char const * liz_license();
HS_API char const * liz_copyright();

#ifdef __cplusplus
}
#endif

#endif //_LXR_LIZ
