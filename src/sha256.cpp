// eLyKseeR C++ -> Haskell bindings
// Copyright 2019 Alexander Diemand
// License: GNU General Public License v3.0

// this implements SHA256 cryptographic hash function
// (see https://github.com/eLyKseeR/elykseer-cpp/blob/master/src/cpp/sha256.hpp.md)

#include "sha256.hpp"
#include "key256.hpp"
#include "lxr/sha256.hpp"

#include "boost/filesystem.hpp"

// our functions need to be C-functions
#ifdef __cplusplus
  extern "C" {
#endif

MT_API HsPtr sha256_buffer(char const *s, int l)
{
  lxr::Key256 k = lxr::Sha256::hash(s,l);
  lxr::Key256 *c = new lxr::Key256(k);
  return (void*)c;
}

MT_API HsPtr sha256_file(char const *s)
{
  boost::filesystem::path fp(s);
  lxr::Key256 k = lxr::Sha256::hash(fp);
  lxr::Key256 *c = new lxr::Key256(k);
  return (void*)c;
}

#ifdef __cplusplus
  }
#endif

