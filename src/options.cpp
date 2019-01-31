// eLyKseeR C++ -> Haskell bindings
// Copyright 2019 Alexander Diemand
// License: GNU General Public License v3.0

// this implements the |Options| data structure
// (see https://github.com/eLyKseeR/elykseer-cpp/blob/master/src/cpp/options.hpp.md)

#include "options.hpp"
#include "lxr/options.hpp"

#include <string>

// our functions need to be C-functions
#ifdef __cplusplus
  extern "C" {
#endif

HS_API void options_release(HsPtr hsptr)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
		delete c;
	}
}

FF_PTR2INT(options_get_nchunks, lxr::Options, nChunks)

HS_API void options_set_nchunks(HsPtr hsptr, int n)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
		c->nChunks(n);
	}
}

FF_PTR2INT(options_get_nredund, lxr::Options, nRedundancy)

HS_API void options_set_nredund(HsPtr hsptr, int n)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
		c->nRedundancy(n);
	}
}

HS_API int options_get_iscompr(HsPtr hsptr)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
		return c->isCompressed()?1:0;
	}
	return false;
}

HS_API void options_set_iscompr(HsPtr hsptr, int n)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
		c->isCompressed(n == 1);
	}
}

HS_API int options_get_isdedup(HsPtr hsptr)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
		return c->isDeduplicated()?1:0;
	}
	return false;
}

HS_API void options_set_isdedup(HsPtr hsptr, int n)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
		c->isDeduplicated(n == 1);
	}
}

HS_API char const * options_get_fpchunks(HsPtr hsptr)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
    std::string s = c->fpathChunks().string();
    return strdup(s.c_str());
  }
	return 0;
}

HS_API void options_set_fpchunks(HsPtr hsptr, char const *fp)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
		c->fpathChunks() = std::string(fp);
	}	
}

HS_API char const * options_get_fpmeta(HsPtr hsptr)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
    std::string s = c->fpathMeta().string();
    return strdup(s.c_str());
  }
	return 0;
}

HS_API void options_set_fpmeta(HsPtr hsptr, char const *fp)
{
	lxr::Options* c = (lxr::Options*)hsptr;
	if (c) {
		c->fpathMeta() = std::string(fp);
	}	
}

HS_API HsPtr options_new()
{
	lxr::Options* c = new lxr::Options();
	return c;
}

#ifdef __cplusplus
  }
#endif

