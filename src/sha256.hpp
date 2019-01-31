#ifndef _LXR_SHA256
#define _LXR_SHA256

#include "FFI.h"

#ifdef __cplusplus
extern "C" {
#endif

HS_API HsPtr sha256_buffer(char const *, int);
HS_API HsPtr sha256_file(char const *);

#ifdef __cplusplus
}
#endif

#endif //_LXR_SHA256
