// eLyKseeR C++ -> Haskell bindings
// Copyright 2019 Alexander Diemand
// License: GNU General Public License v3.0

// this implements key128 cryptographic hash function
// (see https://github.com/eLyKseeR/elykseer-cpp/blob/master/src/cpp/key128.hpp.md)

#include "key128.hpp"
#include "lxr/key128.hpp"

#include <string>

// our functions need to be C-functions
#ifdef __cplusplus
  extern "C" {
#endif

HS_API void key128_release(HsPtr hsptr)
{
	lxr::Key128* c = (lxr::Key128*)hsptr;
	if (c) {
		delete c;
	}
}

FF_PTR2INT(key128_length, lxr::Key128, length)

HS_API HsPtr key128_random()
{
	lxr::Key128* c = new lxr::Key128();
	return (void*)c;
}

HS_API HsPtr key128_fromhex(const char *k, int l)
{
	lxr::Key128* c = new lxr::Key128();
  c->fromBytes((unsigned char const*)k);
	return (void*)c;
}

HS_API char const* key128_tohex(HsPtr hsptr)
{
	lxr::Key128* c = (lxr::Key128*)hsptr;
	if (c) {
    std::string s = c->toHex();
    return strdup(s.c_str());
  }
	return 0;
}

#ifdef __cplusplus
  }
#endif

