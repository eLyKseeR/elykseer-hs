#ifndef _LXR_SHA256
#define _LXR_SHA256

#include "FFI.h"

#ifdef __cplusplus
extern "C" {
#endif

MT_API HsPtr sha256_buffer(char const *, int);
MT_API HsPtr sha256_file(char const *);

#ifdef __cplusplus
}
#endif

#endif //_LXR_SHA256
