// eLyKseeR C++ -> Haskell bindings
// Copyright 2019 Alexander Diemand
// License: GNU General Public License v3.0

// this implements key256 cryptographic hash function
// (see https://github.com/eLyKseeR/elykseer-cpp/blob/master/src/cpp/key256.hpp.md)

#include "key256.hpp"
#include "lxr/key256.hpp"

#include <string>

// our functions need to be C-functions
#ifdef __cplusplus
  extern "C" {
#endif

HS_API void key256_release(HsPtr hsptr)
{
	lxr::Key256* c = (lxr::Key256*)hsptr;
	if (c) {
		delete c;
	}
}

FF_PTR2INT(key256_length, lxr::Key256, length)

HS_API HsPtr key256_random()
{
	lxr::Key256* c = new lxr::Key256();
	return (void*)c;
}

HS_API HsPtr key256_fromhex(const char *k)
{
	lxr::Key256* c = new lxr::Key256();
  c->fromBytes((unsigned char const*)k);
	return (void*)c;
}

HS_API char const* key256_tohex(HsPtr hsptr)
{
	lxr::Key256* c = (lxr::Key256*)hsptr;
	if (c) {
    std::string s = c->toHex();
    return strdup(s.c_str());
  }
	return 0;
}

#ifdef __cplusplus
  }
#endif

