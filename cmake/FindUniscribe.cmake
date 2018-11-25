# This module defines the following variables:
#
# UNISCRIBE_FOUND
#   True if UNISCRIBE found.
#
# UNISCRIBE_INCLUDE_DIRS
#   where to find usp10.h
#
# UNISCRIBE_LIBRARIES
#   The library usp10
#
# This module exports the following IMPORTED target:
#
# UNISCRIBE::UNISCRIBE
#

if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_Uniscribe uniscribe QUIET)
endif()

find_path(UNISCRIBE_INCLUDE_DIR
    NAMES usp10.h
    HINTS ${PC_Uniscribe_INCLUDE_DIRS} ${Uniscribe_ROOT} $ENV{Uniscribe_ROOT})
find_library(UNISCRIBE_LIBRARY
    NAMES usp10
    HINTS ${PC_Uniscribe_INCLUDE_DIRS} ${Uniscribe_ROOT} $ENV{Uniscribe_ROOT})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Uniscribe
    REQUIRED_VARS UNISCRIBE_INCLUDE_DIR UNISCRIBE_LIBRARY)

if(Uniscribe_FOUND)
    set(UNISCRIBE_LIBRARIES ${UNISCRIBE_LIBRARY})
    set(UNISCRIBE_INCLUDE_DIRS ${UNISCRIBE_INCLUDE_DIR})

    if(NOT TARGET Uniscribe::Uniscribe)
        add_library(Uniscribe::Uniscribe UNKNOWN IMPORTED)
        set_target_properties(Uniscribe::Uniscribe PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${UNISCRIBE_INCLUDE_DIR}"
            INTERFACE_LINK_LIBRARIES "${UNISCRIBE_LIBRARY}"
            )
        set_property(TARGET Uniscribe::Uniscribe APPEND PROPERTY IMPORTED_LOCATION "${UNISCRIBE_LIBRARY}")
    endif()
endif()

mark_as_advanced(UNISCRIBE_INCLUDE_DIRS UNISCRIBE_LIBRARIES)
