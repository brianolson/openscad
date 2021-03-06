#
# Try to find GLEW library and include path.
# Once done this will define
#
# GLEW_FOUND
# GLEW_INCLUDE_DIR
# GLEW_LIBRARY
# 

# a few lines of this file are based on the LGPL code found at 
# http://openlibraries.org/browser/trunk/FindGLEW.cmake?rev=1383 

include(FindPkgConfig)

if (PKG_CONFIG_FOUND)
  message("Doing pkg config glew check...")
  pkg_check_modules(GLEW glew>=1.6)
endif()

if (GLEW_LIBRARIES)
  set(GLEW_INCLUDE_DIR "${GLEW_INCLUDE_DIRS}")
  set(GLEW_LIBRARY ${GLEW_LDFLAGS})
else()
  if (WIN32 AND MSVC)
    if (WIN32_STATIC_BUILD) # passed from caller
      set(GLEW_LIB_SEARCH_NAME glew32s.lib) # static, non-debug (Release)
    else ()
      set(GLEW_LIB_SEARCH_NAME glew32.lib) # other. untested with OpenSCAD
    endif()
  else () # GCC
    set(GLEW_LIB_SEARCH_NAME "libglew32s.a")
  endif ()

  if (WIN32)
    find_path(GLEW_INCLUDE_DIR GL/glew.h
      $ENV{PROGRAMFILES}/GLEW/include
      ${PROJECT_SOURCE_DIR}/src/nvgl/glew/include
      DOC "The directory where GL/glew.h resides")
    find_library(GLEW_LIBRARY
      NAMES ${GLEW_LIB_SEARCH_NAME}
      PATHS
      $ENV{PROGRAMFILES}/GLEW/lib
      ${PROJECT_SOURCE_DIR}/src/nvgl/glew/bin
      ${PROJECT_SOURCE_DIR}/src/nvgl/glew/lib
      DOC "The GLEW library")
  else (WIN32)
    find_path(GLEW_INCLUDE_DIR GL/glew.h
      PATHS /usr/include /usr/local/include /usr/pkg/include
      NO_DEFAULT_PATH
      DOC "The directory where GL/glew.h resides")
    find_library(GLEW_LIBRARY
      NAMES GLEW glew
      PATHS /usr/lib /usr/local/lib /usr/pkg/lib
      NO_DEFAULT_PATH
      DOC "The GLEW library")
  endif (WIN32)

  if (GLEW_INCLUDE_DIR)
    set(GLEW_FOUND 1 CACHE STRING "Set to 1 if GLEW is found, 0 otherwise")
    message(STATUS "GLEW include found in " ${GLEW_INCLUDE_DIR} )
    message(STATUS "GLEW library found in " ${GLEW_LIBRARY} )
  else()
    set(GLEW_FOUND 0 CACHE STRING "Set to 1 if GLEW is found, 0 otherwise")
  endif()
endif()
