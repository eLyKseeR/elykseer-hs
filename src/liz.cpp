// eLyKseeR C++ -> Haskell bindings
// Copyright 2019 Alexander Diemand
// License: GNU General Public License v3.0

// this implements license related functions
// (see https://github.com/eLyKseeR/elykseer-cpp/blob/master/src/cpp/liz.hpp.md)

#include "liz.hpp"
#include "lxr/liz.hpp"

// our functions need to be C-functions
#ifdef __cplusplus
  extern "C" {
#endif

MT_API char liz_verify()
{
  return lxr::Liz::verify();
}

MT_API int liz_daysleft()
{
  return lxr::Liz::daysLeft();
}

MT_API char const * liz_name()
{
  std::string s = lxr::Liz::name();
  return strdup(s.c_str());
}

MT_API char const * liz_version()
{
  std::string s = lxr::Liz::version();
  return strdup(s.c_str());
}

MT_API char const * liz_copyright()
{
  std::string s = lxr::Liz::copyright();
  return strdup(s.c_str());
}

MT_API char const * liz_license()
{
  std::string s = lxr::Liz::license();
  return strdup(s.c_str());
}

#ifdef __cplusplus
  }
#endif

