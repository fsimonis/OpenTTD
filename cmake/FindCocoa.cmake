# - Try to find Cocoa
# Once done, this will define
#
#  Cocoa_FOUND - system has Cocoa
#  Cocoa_INCLUDE_DIRS - the Cocoa include directories 
#  Cocoa_LIBRARIES - link these to use Cocoa
#
#  Cocoa::Cocoa - imported library as target

if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_Cocoa cocoa QUIET)
endif()

find_path(Cocoa_INCLUDE_DIRS NAMES Cocoa.h HINTS ${PC_Cocoa_INCLUDE_DIRS} ${Cocoa_ROOT} PATH_SUFFIXES Cocoa)
find_library(Cocoa_LIBRARIES NAMES Cocoa HINTS ${PC_Cocoa_LIBRARY_DIRS} ${Cocoa_ROOT})

set(Cocoa_VERSION ${PC_Cocoa_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cocoa 
    REQUIRED_VARS Cocoa_LIBRARIES Cocoa_INCLUDE_DIRS
    VERSION_VAR Cocoa_VERSION
    )

if(Cocoa_FOUND)
    if(NOT TARGET Cocoa::Cocoa)
        add_library(Cocoa::Cocoa UNKNOWN IMPORTED)
        set_target_properties(Cocoa::Cocoa PROPERTIES
            INTERFACE_LINK_LIBRARIES ${Cocoa_LIBRARIES}
            INTERFACE_INCLUDE_DIR ${Cocoa_INCLUDE_DIRS}
            )
    endif()
endif()

mark_as_advanced(Cocoa_INCLUDE_DIRS Cocoa_LIBRARIES)
