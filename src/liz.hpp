#ifndef _LXR_LIZ
#define _LXR_LIZ

#include "FFI.h"

#ifdef __cplusplus
extern "C" {
#endif

MT_API char liz_verify();
MT_API int liz_daysleft();

MT_API char const * liz_name();
MT_API char const * liz_version();
MT_API char const * liz_license();
MT_API char const * liz_copyright();

#ifdef __cplusplus
}
#endif

#endif //_LXR_LIZ
