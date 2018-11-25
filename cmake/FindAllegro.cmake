# This module defines the following variables:
#
# ALLEGRO_FOUND
#   True if ALLEGRO found.
#
# ALLEGRO_INCLUDE_DIRS
#   where to find usp10.h
#
# ALLEGRO_LIBRARIES
#   The library usp10
#
# This module exports the following IMPORTED target:
#
# ALLEGRO::ALLEGRO

if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_Allegro allegro QUIET)
endif()

find_path(ALLEGRO_INCLUDE_DIR
    NAMES allegro.h
    HINTS $ENV{MINGDIR}/include ${PC_Allegro_INCLUDE_DIRS} ${ALLEGRO_ROOT} $ENV{ALLEGRO_ROOT}
    PATH_SUFFIXES allegro4 allegro
    )
find_library(ALLEGRO_LIBRARY
    NAMES alleg alleglib alleg41 alleg42 allegdll allegro liballegro
    HINTS $ENV{MINGDIR}/lib ${PC_Allegro_LIBRARY_DIRS} ${ALLEGRO_ROOT} $ENV{ALLEGRO_ROOT}
    PATH_SUFFIXES allegro4 allegro
    )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ALLEGRO
    REQUIRED_VARS ALLEGRO_INCLUDE_DIR ALLEGRO_LIBRARY)

if(ALLEGRO_FOUND)
    set(ALLEGRO_LIBRARIES ${ALLEGRO_LIBRARY})
    set(ALLEGRO_INCLUDE_DIRS ${ALLEGRO_INCLUDE_DIR})

    if(NOT TARGET ALLEGRO::ALLEGRO)
        add_library(ALLEGRO::ALLEGRO UNKNOWN IMPORTED)
        set_target_properties(ALLEGRO::ALLEGRO PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${ALLEGRO_INCLUDE_DIR}"
            INTERFACE_LINK_LIBRARIES "${ALLEGRO_LIBRARY}"
            )
        set_property(TARGET ALLEGRO::ALLEGRO APPEND PROPERTY IMPORTED_LOCATION "${ALLEGRO_LIBRARY}")
    endif()
endif(ALLEGRO_FOUND)

mark_as_advanced(ALLEGRO_LIBRARIES ALLEGRO_INCLUDE_DIRS)
