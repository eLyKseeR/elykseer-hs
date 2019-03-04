// eLyKseeR C++ -> Haskell bindings
// Copyright 2019 Alexander Diemand
// License: GNU General Public License v3.0

// this implements DbFp
// (see https://github.com/eLyKseeR/elykseer-cpp/blob/master/src/cpp/dbfp.hpp.md)

#include "dbfp.hpp"
#include "lxr/dbfp.hpp"

#include <iostream>
#include <fstream>

#include "boost/filesystem.hpp"

// our functions need to be C-functions
#ifdef __cplusplus
  extern "C" {
#endif

HS_API int dbfp_count(HsPtr hsptr)
{
	lxr::DbFp* c = (lxr::DbFp*)hsptr;
	if (c) {
		return c->count();
	}
  return 0;
}

HS_API bool dbfp_contains(HsPtr hsptr, char const *k)
{
	lxr::DbFp* c = (lxr::DbFp*)hsptr;
	if (c) {
		return c->contains(std::string(k));
	}
	return false;
}

HS_API void dbfp_instream(HsPtr hsptr, char const *p)
{
	const std::string fp(p);
	if (! boost::filesystem::exists(fp)) { return; }
	lxr::DbFp* c = (lxr::DbFp*)hsptr;
	if (c) {
		std::ifstream _ins; _ins.open(fp);
		c->inStream(_ins);
	}
}

HS_API void dbfp_outstream(HsPtr hsptr, char const *p)
{
	const std::string fp(p);
	if (boost::filesystem::exists(fp)) { return; }
	lxr::DbFp* c = (lxr::DbFp*)hsptr;
	if (c) {
		std::ofstream _outs; _outs.open(fp);
		c->outStream(_outs);
	}
}

#ifdef __cplusplus
  }
#endif

