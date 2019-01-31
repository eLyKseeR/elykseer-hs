// eLyKseeR C++ -> Haskell bindings
// Copyright 2019 Alexander Diemand
// License: GNU General Public License v3.0

// this implements MD5 cryptographic hash function
// (see https://github.com/eLyKseeR/elykseer-cpp/blob/master/src/cpp/md5.hpp.md)

#include "md5.hpp"
#include "key128.hpp"
#include "lxr/md5.hpp"

#include "boost/filesystem.hpp"

// our functions need to be C-functions
#ifdef __cplusplus
  extern "C" {
#endif

HS_API HsPtr md5_buffer(char const *s, int l)
{
  lxr::Key128 k = lxr::Md5::hash(s,l);
  lxr::Key128 *c = new lxr::Key128(k);
  return (void*)c;
}

#ifdef __cplusplus
  }
#endif

