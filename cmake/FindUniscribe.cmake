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
find_path(UNISCRIBE_INCLUDE_DIR NAMES usp10.h)
mark_as_advanced(UNISCRIBE_INCLUDE_DIR)

find_library(UNISCRIBE_LIBRARY NAMES usp10)
mark_as_advanced(UNISCRIBE_LIBRARY)

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
