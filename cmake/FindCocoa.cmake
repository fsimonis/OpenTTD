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

find_path(Cocoa_INCLUDE_DIRS NAMES Cocoa.h HINTS ${PC_Cocoa_INCLUDE_DIRS} PATH_SUFFIXES Cocoa)
find_library(Cocoa_LIBRARIES NAMES Cocoa HINTS ${PC_Cocoa_LIBRARY_DIRS})


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cocoa DEFAULT_MSG Cocoa_LIBRARIES Cocoa_INCLUDE_DIRS)

if(Cocoa_FOUND)
    if(NOT TARGET Cocoa::Cocoa)
        add_library(Cocoa::Cocoa UNKNOWN IMPORTED)
        target_include_directories(Cocoa::Cocoa INTERFACE ${Cocoa_INCLUDE_DIRS})
        target_link_libraries(Cocoa::Cocoa INTERFACE ${Cocoa_LIBRARIES})
    endif()
endif()

mark_as_advanced(Cocoa_INCLUDE_DIRS Cocoa_LIBRARIES)
