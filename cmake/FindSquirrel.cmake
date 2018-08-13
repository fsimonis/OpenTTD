# - Try to find Squirrel
# Once done this will define
#
#  Squirrel_FOUND - system has Squirrel
#  Squirrel_INCLUDE_DIR - the include directory
#  Squirrel_LIBRARY - The Squirrel library
#  Squirrel_STD_LIBRARY - The Squirrel std library


FIND_PATH(Squirrel_INCLUDE_DIR squirrel.h PATH_SUFFIXES squirrel)
FIND_LIBRARY(Squirrel_LIBRARY NAMES squirrel PATH_SUFFIXES squirrel)
FIND_LIBRARY(Squirrel_STD_LIBRARY NAMES sqstdlib PATH_SUFFIXES squirrel)

MARK_AS_ADVANCED(Squirrel_INCLUDE_DIR Squirrel_LIBRARY)

IF(Squirrel_INCLUDE_DIR AND Squirrel_LIBRARY)
	SET(Squirrel_FOUND TRUE)
ELSE(Squirrel_INCLUDE_DIR AND Squirrel_LIBRARY)
	SET(Squirrel_FOUND FALSE)
ENDIF(Squirrel_INCLUDE_DIR AND Squirrel_LIBRARY)


# FindSquirrel.cmake
#
# Finds the Squirrel library
#
# This will define the following variables
#
#    Squirrel_FOUND
#    Squirrel_INCLUDE_DIRS
#    Squirrel_LIBRARIES
#    Squirrel_STD_LIBRARY
#
# and the following imported targets
#
#     Squirrel::Squirrel
#

find_package(PkgConfig)
pkg_check_modules(PC_Squirrel QUIET Squirrel)

find_path(Squirrel_INCLUDE_DIR
    NAMES squirrel.h
    PATHS ${PC_Squirrel_INCLUDE_DIRS}
    PATH_SUFFIXES squirrel
)
find_library(Squirrel_LIBRARY NAMES squirrel HINTS ${Squirrel_INCLUDE_DIR} PATH_SUFFIXES squirrel)
find_library(Squirrel_STD_LIBRARY HINTS ${Squirrel_INCLUDE_DIR} NAMES sqstdlib PATH_SUFFIXES squirrel)

set(Squirrel_VERSION ${PC_Squirrel_VERSION})

mark_as_advanced(Squirrel_FOUND Squirrel_INCLUDE_DIR Squirrel_LIBRARY Squirrel_STD_LIBRARY Squirrel_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Squirrel
    REQUIRED_VARS Squirrel_INCLUDE_DIR
    VERSION_VAR Squirrel_VERSION
)

if(Squirrel_FOUND)
    set(Squirrel_INCLUDE_DIRS ${Squirrel_INCLUDE_DIR})
    set(Squirrel_LIBRARIES ${Squirrel_LIBRARY})
endif()

if(Squirrel_FOUND AND NOT TARGET Squirrel::Squirrel)
    add_library(Squirrel::Squirrel INTERFACE IMPORTED)
    set_target_properties(Squirrel::Squirrel PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${Squirrel_INCLUDE_DIR}"
        INTERFACE_LINK_LIBRARIES ${Squirrel_LIBRARY}
    )
endif()
