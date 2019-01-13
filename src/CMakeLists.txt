cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

IF(DEFINED CMAKE_BUILD_TYPE)
	SET(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release DebugProfile RelWithDebInfo MinSizeRel.")
ELSE()
	SET(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release DebugProfile RelWithDebInfo MinSizeRel.")
ENDIF()

add_definitions( -D__MT_DLL_EXPORT )

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g -O1 -fPIC")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -g -fPIC")
set(CMAKE_LD_FLAGS "${CMAKE_LD_FLAGS} -fPIC")

# OS dependent
IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(CMAKE_OSX_DEPLOYMENT_TARGET "10.12.0")
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

# boost
add_definitions( -DBOOST_ALL_DYN_LINK )
set(Boost_ADDITIONAL_VERSIONS "1.55")
set(Boost_DEBUG OFF)
set(Boost_USE_STATIC_LIBS OFF)
set(Boost_USE_STATIC_RUNTIME OFF)
set(Boost_USE_MULTITHREADED ON)
find_package( Boost 1.59.0 REQUIRED COMPONENTS system filesystem chrono thread date_time iostreams )
LINK_DIRECTORIES ( ${Boost_LIBRARY_DIRS} )
INCLUDE_DIRECTORIES (${Boost_INCLUDE_DIRS})

# mine
include_directories(".")
# lxr
include_directories("../ext/elykseer-cpp/cpp/src/")

# link external libraries
link_directories("${CMAKE_HOME_DIRECTORY}/ext/")
IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
   # Mac OS X specific code
   set(libs "dl" "z" "prngCpp_s.osx.1.0.4")
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  # Linux specific code
  set(libs "dl" "z" "prngCpp_s.linux.1.0.4")
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")

# list of source files to be compiled
file(GLOB SRCS *.cpp *.c)

# linking statically
add_library(libelykseer-cpp STATIC IMPORTED)
set_target_properties(libelykseer-cpp PROPERTIES
  IMPORTED_LOCATION ${CMAKE_HOME_DIRECTORY}/ext/libelykseer-cpp_Debug_s.a)


add_library (${PROJECT_NAME}_${CMAKE_BUILD_TYPE}_s STATIC
	${SRCS}
)
target_link_libraries (${PROJECT_NAME}_${CMAKE_BUILD_TYPE}_s
	${libs}
  elykseer-cpp_Debug
	${Boost_LIBRARIES}
)

add_library (${PROJECT_NAME}_${CMAKE_BUILD_TYPE} SHARED
	${SRCS}
)
target_link_libraries (${PROJECT_NAME}_${CMAKE_BUILD_TYPE}
	${libs}
  elykseer-cpp_Debug
	${Boost_LIBRARIES}
)

set_target_properties(${PROJECT_NAME}_${CMAKE_BUILD_TYPE} PROPERTIES
                      VERSION ${elykseer-hs_VERSION_STRING}
                      SOVERSION ${elykseer-hs_VERSION_MAJOR})

#add_subdirectory( tests )

# done.

