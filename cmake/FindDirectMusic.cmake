# - Try to find DirectMusic
# Once done, this will define
#
#  DirectMusic_FOUND - system has DirectMusic
#  DirectMusic_INCLUDE_DIRS - the DirectMusic include directories 
#  DirectMusic_LIBRARIES - link these to use DirectMusic
#
#  DirectMusic::DirectMusic - imported library as target

if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_DirectMusic directmusic QUIET) # TODO Verify
endif()

find_path(DirectMusic_INCLUDE_DIR
    NAMES DirectMusic.h
    HINTS ${PC_DirectMusic_INCLUDE_DIRS} ${DirectMusic_ROOT} $ENV{DirectMusic_ROOT}
    PATH_SUFFIXES DirectMusic)
find_library(DirectMusic_LIBRARY
    NAMES DirectMusic
    HINTS ${PC_DirectMusic_LIBRARY_DIRS} ${DirectMusic_ROOT} $ENV{DirectMusic_ROOT}
    PATH_SUFFIXES DirectMusic)

set(DirectMusic_VERSION ${PC_DirectMusic_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DirectMusic 
    REQUIRED_VARS DirectMusic_LIBRARY DirectMusic_INCLUDE_DIR
    VERSION_VAR DirectMusic_VERSION
    )

if(DirectMusic_FOUND)
    set(DirectMusic_INCLUDE_DIRS ${DirectMusic_INCLUDE_DIR})
    set(DirectMusic_LIBRARIES ${DirectMusic_LIBRARY})

    if(NOT TARGET DirectMusic::DirectMusic)
        add_library(DirectMusic::DirectMusic UNKNOWN IMPORTED)
        set_target_properties(DirectMusic::DirectMusic PROPERTIES
            INTERFACE_LINK_LIBRARIES ${DirectMusic_LIBRARIES}
            INTERFACE_INCLUDE_DIR ${DirectMusic_INCLUDE_DIRS}
            )
    endif()
endif()

mark_as_advanced(DirectMusic_INCLUDE_DIRS DirectMusic_LIBRARIES)
