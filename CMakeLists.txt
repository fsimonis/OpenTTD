cmake_minimum_required(VERSION 3.8)
project(openttd VERSION 1.7.2 LANGUAGES CXX)

# Also search the project cmake directory for modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

# Detect OS2
if (CMAKE_SYSTEM_NAME EQUAL "OS2")
    set(OS2 "yes")
endif()

cmake_host_system_information(RESULT HAS_SSE QUERY HAS_SSE)

find_package(PNG)
find_package(ZLIB)
find_package(LZO2)
find_package(LibLZMA)
find_package(Freetype)
find_package(FontConfig)
# find_package(ICU REQUIRED)
find_package(SDL)
find_package(Allegro)
find_package(Cocoa)

if(NOT CMAKE_INSTALL_PREFIX)
    set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
set(OPENTTD_REL_BINARY_DIR "games" CACHE STRING "relative to prefix")
set(OPENTTD_REL_DATA_DIR "share/games/openttd" CACHE STRING "relative to prefix")
set(OPENTTD_REL_ICON_DIR "share/pixmaps" CACHE STRING "relative to prefix")

set(OPENTTD_BINARY_DIR "${CMAKE_INSTALL_PREFIX}/${OPENTTD_REL_BINARY_DIR}")
set(OPENTTD_DATA_DIR   "${CMAKE_INSTALL_PREFIX}/${OPENTTD_REL_DATA_DIR}")
set(OPENTTD_ICON_DIR   "${CMAKE_INSTALL_PREFIX}/${OPENTTD_REL_ICON_DIR}")

# Detect Version, Modified and Date
include(cmake/DetectVersion.cmake)

# Configure files

# VERSION DATE MODIFIED
configure_file(src/rev.cpp.in src/rev.cpp @ONLY)
# ISODATE VERSION
configure_file(src/os/windows/ottdres.rc.in src/os/windows/ottdres.rc @ONLY)
# MENU_NAME TTD MENU_GROUP
configure_file(media/openttd.desktop.in media/openttd.desktop @ONLY)


#
# Strings generator
#

# Add the string_gen as an empty target.
add_executable(string_gen)

# Set the C++ Standard to C++11
target_compile_features(string_gen
    PUBLIC
    cxx_std_11
    )

# Add the needed compile time definition "SETTINGSGEN" to the target.
target_compile_definitions(string_gen
    PRIVATE
    STRGEN
    )

# Add the sources for the settings_gen.
target_sources(string_gen
    PRIVATE
    src/core/alloc_func.cpp
    src/misc/getoptdata.cpp
    src/misc/getoptdata.h
    src/safeguards.h
    src/strgen/strgen.cpp
    src/strgen/strgen.h
    src/strgen/strgen_base.cpp
    src/string.cpp
    src/table/control_codes.h
    src/table/strgen_tables.h
    )

# Add the include directories for the target
target_include_directories(string_gen
    PRIVATE 
    src
    # Include configured files from the build-tree
    ${CMAKE_CURRENT_BINARY_DIR}/src
    )


# Add the command that generates the src/table/strings.h header file.
add_custom_command(
    OUTPUT src/table/strings.h
    COMMAND $<TARGET_FILE:string_gen> -s ${CMAKE_SOURCE_DIR}/src/lang -d ${CMAKE_CURRENT_BINARY_DIR}/src/table
    DEPENDS string_gen ${CMAKE_SOURCE_DIR}/src/lang/english.txt
    COMMENT Generating Strings
    )

file(GLOB LANGUAGE_FILES src/lang/*.txt)
set(LANGUAGE_LNG_FILES "")
foreach(LANGUAGE_FILE ${LANGUAGE_FILES})
    get_filename_component(LANGUAGE "${LANGUAGE_FILE}" NAME_WE)
    list(APPEND LANGUAGE_LNG_FILES "objs/lang/${LANGUAGE}.lng")
    add_custom_command(
        OUTPUT objs/lang/${LANGUAGE}.lng
        COMMAND $<TARGET_FILE:string_gen> -s ${CMAKE_SOURCE_DIR}/src/lang -d ${CMAKE_CURRENT_BINARY_DIR}/objs/lang ${LANGUAGE_FILE}
        DEPENDS string_gen ${LANGUAGE_FILE}
        COMMENT Generating Language: ${LANGUAGE}
        )
endforeach()
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/objs/lang")

#
# Settings generator
#

# Add the settings_gen as an empty target.
add_executable(settings_gen)

# Set the C++ Standard to C++11
target_compile_features(settings_gen
    PUBLIC
    cxx_std_11
    )

# Add the needed compile time definition "SETTINGSGEN" to the target.
target_compile_definitions(settings_gen
    PRIVATE
    SETTINGSGEN
    )

# Add the sources for the settings_gen.
target_sources(settings_gen
    PRIVATE
    src/core/alloc_func.cpp
    src/core/mem_func.hpp
    src/core/smallvec_type.hpp
    src/ini_load.cpp
    src/ini_type.h
    src/misc/getoptdata.cpp
    src/misc/getoptdata.h
    src/safeguards.h
    src/settingsgen/settingsgen.cpp
    src/string.cpp
    src/string_func.h
    src/strings_type.h
    )

# Add the include directories for the target
target_include_directories(settings_gen
    PRIVATE 
    src
    # Include configured files from the build-tree
    ${CMAKE_CURRENT_BINARY_DIR}/src
    )

file(GLOB SETTINGS_TABLE_INI src/table/*.ini)

# Add the command that generates the settings.h header file.
add_custom_command(
    OUTPUT src/table/settings.h
    COMMAND $<TARGET_FILE:settings_gen> -o ${CMAKE_CURRENT_BINARY_DIR}/src/table/settings.h -b ${CMAKE_SOURCE_DIR}/src/table/settings.h.preamble -a ${CMAKE_SOURCE_DIR}/src/table/settings.h.postamble ${SETTINGS_TABLE_INI}
    DEPENDS settings_gen src/table/settings.h.preamble src/table/settings.h.postamble ${SETTINGS_TABLE_INI}
    COMMENT Generating Settings
    )
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/src/table)

#
# The OpenTTD executable
#

# Add openttd as en empty target.
# See src/CMakeLists.txt for the sources.
add_executable(openttd)

# Add the sources subtree
add_subdirectory(src)

# Set the C++ Standard to C++11
target_compile_features(openttd PUBLIC cxx_std_11)

# Add the needed compile time definitions
target_compile_definitions(openttd
    PRIVATE
    "GLOBAL_DATA_DIR=\"${OPENTTD_DATA_DIR}\""
    )

# Add the directories to look up includes.
target_include_directories(openttd
    PRIVATE 
    ${CMAKE_SOURCE_DIR}/src
    # Include configured files from the build-tree
    ${CMAKE_CURRENT_BINARY_DIR}/src
    )


# Add detected system libraries to link to.
if(PNG_FOUND)
    target_link_libraries(openttd PRIVATE PNG::PNG)
endif()

if(ZLIB_FOUND)
    target_link_libraries(openttd PRIVATE ZLIB::ZLIB)
endif()

if(LZO2_FOUND)
    target_link_libraries(openttd PRIVATE LZO2::LZO2)
endif()

if(LZMA_FOUND)
    add_library(LZMA UNKNOWN IMPORTED)
    target_link_libraries(LZMA INTERFACE LIBLZMA_LIBRARY)
    target_include_directories(LZMA INTERFACE LIBLZMA_INCLUDE_DIR)

    target_link_libraries(openttd PRIVATE LZMA)
endif()

if(Freetype_FOUND)
    target_link_libraries(openttd PRIVATE Freetype::Freetype)
endif()

if(FontConfig_FOUND)
    target_link_libraries(openttd PRIVATE FontConfig::FontConfig)
endif()

if(ICU_FOUND)
    # Use the ICU unicode library
    target_link_libraries(openttd PRIVATE ICU::uc)
endif()
if(Allegro_FOUND)
    target_link_libraries(openttd PRIVATE Allegro::Allegro)
endif()

# Add third party libraries to link to.
target_link_libraries(openttd
    PRIVATE
    Squirrel
    SqStdLib
    MD5
    )

# Explicitly add the dependency to the version configuration.
# add_dependencies(openttd configure_version)

target_sources(openttd
    PRIVATE
    src/table/strings.h
    ${LANGUAGE_LNG_FILES}
    )

# Add the objects subtree
# add_subdirectory(objs)

# TODO: Add the documentation subtree
# add_subdirectory(doc)
