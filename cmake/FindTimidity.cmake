# - Try to find Timidity
# Once done, this will define
#
#  Timidity_FOUND - system has Timidity
#  Timidity_INCLUDE_DIRS - the Timidity include directories 
#  Timidity_LIBRARIES - link these to use Timidity
#
#  Timidity::Timidity - imported library as target

if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_Timidity timidity QUIET)
endif()

find_path(Timidity_INCLUDE_DIR
    NAMES Timidity.h
    HINTS ${PC_Timidity_INCLUDE_DIRS} ${Timidity_ROOT} $ENV{Timidity_ROOT}
    PATH_SUFFIXES Timidity)
find_library(Timidity_LIBRARY
    NAMES Timidity
    HINTS ${PC_Timidity_LIBRARY_DIRS} ${Timidity_ROOT} $ENV{Timidity_ROOT}
    PATH_SUFFIXES Timidity)

set(Timidity_VERSION ${PC_Timidity_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Timidity 
    REQUIRED_VARS Timidity_LIBRARY Timidity_INCLUDE_DIR
    VERSION_VAR Timidity_VERSION
    )

if(Timidity_FOUND)
    set(Timidity_INCLUDE_DIRS ${Timidity_INCLUDE_DIR})
    set(Timidity_LIBRARIES ${Timidity_LIBRARY})

    if(NOT TARGET Timidity::Timidity)
        add_library(Timidity::Timidity UNKNOWN IMPORTED)
        set_target_properties(Timidity::Timidity PROPERTIES
            INTERFACE_LINK_LIBRARIES ${Timidity_LIBRARIES}
            INTERFACE_INCLUDE_DIR ${Timidity_INCLUDE_DIRS}
            )
    endif()
endif()

mark_as_advanced(Timidity_INCLUDE_DIRS Timidity_LIBRARIES)
