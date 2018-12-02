cmake_minimum_required(VERSION 3.8)
project(openttd VERSION 1.7.2 LANGUAGES CXX C)

# Also search the project cmake directory for modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

#
# Extended Host Support
#

# Detect OS2
if (CMAKE_SYSTEM_NAME EQUAL "OS2")
    set(OS2 YES)
endif()

# Option for PSP
option(PSP "Target PSP?" OFF)

# Option for BeOS
option(BEOS "Target BeOS?" OFF)

#
# Options and Cached Variables
#

if(NOT CMAKE_INSTALL_PREFIX)
    set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
set(OPENTTD_REL_BINARY_DIR "games" CACHE STRING "relative to prefix")
set(OPENTTD_REL_DATA_DIR "share/games/openttd" CACHE STRING "relative to prefix")
set(OPENTTD_REL_ICON_DIR "share/pixmaps" CACHE STRING "relative to prefix")
set(OPENTTD_PERSONAL_DIR "" CACHE STRING "The personal directory to use.")

set(OPENTTD_BINARY_DIR "${CMAKE_INSTALL_PREFIX}/${OPENTTD_REL_BINARY_DIR}")
set(OPENTTD_DATA_DIR   "${CMAKE_INSTALL_PREFIX}/${OPENTTD_REL_DATA_DIR}")
set(OPENTTD_ICON_DIR   "${CMAKE_INSTALL_PREFIX}/${OPENTTD_REL_ICON_DIR}")

# Migrated options from config.lib

option(OPENTTD_DEDICATED "build dedicated server" OFF)
option(OPENTTD_OSX_SYSROOT        "Compile with osx_sysroot"        ON)
option(OPENTTD_APPLICATION_BUNDLE "Compile with application_bundle" ON)
option(OPENTTD_MENU_ENTRY         "Compile with menu_entry"         ON)
option(OPENTTD_ALLEGRO            "Compile with allegro"            ON)
option(OPENTTD_SDL                "Compile with sdl"                ON)
option(OPENTTD_COCOA              "Compile with cocoa"              ON) #TODO check
option(OPENTTD_COCOA_QUARTZ       "Enable cocoa_quartz"             ON) #TODO
option(OPENTTD_COCOA_QUICKDRAW    "Enable cocoa_quickdraw"          ON) #TODO
option(OPENTTD_ZLIB               "Compile with zlib"               ON)
option(OPENTTD_LZMA               "Compile with lzma"               ON)
option(OPENTTD_LZO2               "Compile with lzo2"               ON)
option(OPENTTD_XDG_BASEDIR        "Compile with xdg_basedir"        ON) #TODO
option(OPENTTD_PNG                "Compile with png"                ON)
option(OPENTTD_MAKEDEPEND         "Compile with makedepend"         OFF) #TODO
option(OPENTTD_DIRECT_MUSIC       "Compile with direct_music"       ON) #TODO check
option(OPENTTD_XAUDIO2            "Compile with xaudio2"            ON) #TODO
option(OPENTTD_SORT               "Compile with sort"               ON) #TODO
option(OPENTTD_ICONV              "Compile with iconv"              ON)
option(OPENTTD_ICONV_NON_CONST    "Is the iconv implementation non-const?" ON) # TODO treat in code
option(OPENTTD_LIBTIMIDITY        "Compile with libtimidity"        ON) #TODO check
option(OPENTTD_FREETYPE           "Compile with freetype"           ON)
option(OPENTTD_FONTCONFIG         "Compile with fontconfig"         ON)
option(OPENTTD_ICU_LAYOUT         "Compile with icu_layout"         ON)
option(OPENTTD_ICU_SORT           "Compile with icu_sort"           ON)
option(OPENTTD_UNISCRIBE          "Compile with uniscribe"          ON) #TODO check
option(OPENTTD_THREADS            "Compile with threads"            ON) #DEP?
option(OPENTTD_DISTCC             "Compile with distcc"             ON) #DEP
option(OPENTTD_CCACHE             "Compile with ccache"             ON) #DEP
option(OPENTTD_NFORENUM           "Compile with nforenum"           ON) #TODO
option(OPENTTD_GRFCODEC           "Compile with grfcodec"           ON) #TODO
option(OPENTTD_SSE                "Compile with sse"                ON)

option(OPENTTD_DEBUG              "Enable debug"                    OFF) # DEP
option(OPENTTD_DESYNC_DEBUG       "Enable desync_debug"             OFF)
option(OPENTTD_PROFILING          "Enable profiling"                OFF)
option(OPENTTD_LTO                "Enable lto"                      OFF) # DEP
option(OPENTTD_DEDICATED          "Enable dedicated"                OFF)
option(OPENTTD_NETWORK            "Enable network"                  ON )
option(OPENTTD_STATIC             "Enable static"                   ON )
option(OPENTTD_TRANSLATOR         "Enable translator"               OFF)
option(OPENTTD_UNICODE            "Enable unicode"                  ON )
option(OPENTTD_CONSOLE            "Enable console"                  ON )
option(OPENTTD_ASSERT             "Enable asserts"                  ON )
option(OPENTTD_STRIP              "Enable strip"                    OFF)
option(OPENTTD_UNIVERSAL          "Enable universal"                OFF)
option(OPENTTD_OSX_G5             "Enable osx_g5"                   OFF)

if(OPENTTD_DIRECT_MUSIC)
    find_package(DirectMusic REQUIRED)
endif(OPENTTD_DIRECT_MUSIC)

if(OPENTTD_LIBTIMIDITY)
    find_package(Timidity REQUIRED)
endif(OPENTTD_LIBTIMIDITY)

if(OPENTTD_ICU_SORT OR OPENTTD_ICU_LAYOUT)
    find_package(ICU REQUIRED)
endif(OPENTTD_ICU_SORT OR OPENTTD_ICU_LAYOUT)

if(OPENTTD_SDL)
    find_package(SDL REQUIRED)
    add_library(SDL INTERFACE)
    set_target_properties(SDL PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${SDL_INCLUDE_DIR}"
        INTERFACE_LINK_LIBRARIES "${SDL_LIBRARY}"
    )
endif(OPENTTD_SDL)

if(OPENTTD_ALLEGRO)
    find_package(Allegro REQUIRED)
endif(OPENTTD_ALLEGRO)

if(OPENTTD_COCOA)
    find_package(Cocoa REQUIRED)
endif(OPENTTD_COCOA)

if(OPENTTD_PNG)
    find_package(PNG REQUIRED)
endif(OPENTTD_PNG)

if(OPENTTD_ZLIB)
    find_package(ZLIB REQUIRED)
endif(OPENTTD_ZLIB)

if(OPENTTD_LZO2)
    find_package(LZO2 REQUIRED)
endif(OPENTTD_LZO2)

if(OPENTTD_LZMA)
    find_package(LibLZMA REQUIRED)
    add_library(LZMA INTERFACE)
    set_target_properties(LZMA PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${LIBLZMA_INCLUDE_DIRS}"
        INTERFACE_LINK_LIBRARIES "${LIBLZMA_LIBRARIES}"
        )
endif(OPENTTD_LZMA)

if(OPENTTD_FREETYPE)
    find_package(Freetype REQUIRED)
endif(OPENTTD_FREETYPE)

if(OPENTTD_FONTCONFIG)
    find_package(FontConfig REQUIRED)
endif(OPENTTD_FONTCONFIG)

if(OPENTTD_UNISCRIBE)
    find_package(Uniscribe REQUIRED)
endif(OPENTTD_UNISCRIBE)

if(OPENTTD_THREADS)
    find_package(Threads REQUIRED)
endif(OPENTTD_THREADS)

if(OPENTTD_SSE)
    # Check that the compiler has intrinsics enabled
    include(cmake/CheckSSE.cmake)
    check_sse()
endif(OPENTTD_SSE)

# Detect Version, Modified and Date
include(cmake/DetectVersion.cmake)

# Configure files

# VERSION DATE MODIFIED
configure_file(src/rev.cpp.in src/rev.cpp @ONLY)
# ISODATE VERSION
configure_file(src/os/windows/ottdres.rc.in src/os/windows/ottdres.rc @ONLY)
# MENU_NAME TTD MENU_GROUP
configure_file(media/openttd.desktop.in media/openttd.desktop @ONLY)

# Copy baseset
file(COPY bin/ DESTINATION ${CMAKE_CURRENT_BINARY_DIR})


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
    list(APPEND LANGUAGE_LNG_FILES "${CMAKE_CURRENT_BINARY_DIR}/lang/${LANGUAGE}.lng")
    add_custom_command(
        OUTPUT lang/${LANGUAGE}.lng
        COMMAND $<TARGET_FILE:string_gen> -s ${CMAKE_SOURCE_DIR}/src/lang -d ${CMAKE_CURRENT_BINARY_DIR}/lang ${LANGUAGE_FILE}
        DEPENDS string_gen ${LANGUAGE_FILE}
        COMMENT Generating Language: ${LANGUAGE}
        )
endforeach()
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/lang")

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


#
# Link to libraries
#


if(OS2)
    target_link_libraries(openttd PRIVATE OS2)
endif()

if(OPENTTD_PNG)
    target_link_libraries(openttd PRIVATE PNG::PNG)
target_compile_definitions(openttd PRIVATE WITH_PNG)
endif()

if(OPENTTD_ZLIB)
    target_link_libraries(openttd PRIVATE ZLIB::ZLIB)
target_compile_definitions(openttd PRIVATE WITH_ZLIB)
endif()

if(OPENTTD_LZO2)
    target_link_libraries(openttd PRIVATE LZO2::LZO2)
target_compile_definitions(openttd PRIVATE WITH_LZO)
endif()

if(OPENTTD_LZMA)
    target_link_libraries(openttd PRIVATE LZMA)
target_compile_definitions(openttd PRIVATE WITH_LZMA)
endif()

if(OPENTTD_FREETYPE)
    target_link_libraries(openttd PRIVATE Freetype::Freetype)
target_compile_definitions(openttd PRIVATE WITH_FREETYPE)
endif()

if(OPENTTD_FONTCONFIG)
target_compile_definitions(openttd PRIVATE WITH_FONTCONFIG)
    target_link_libraries(openttd PRIVATE FontConfig::FontConfig)
endif()

if(OPENTTD_ICU_SORT OR OPENTTD_ICU_LAYOUT)
    target_link_libraries(openttd PRIVATE ICU::uc)
    if(OPENTTD_ICU_LAYOUT)
        target_compile_definitions(openttd PRIVATE WITH_ICU_LAYOUT)
    endif()
    if(OPENTTD_ICU_SORT)
        target_compile_definitions(openttd PRIVATE WITH_ICU_SORT)
    endif()
endif()

if(OPENTTD_ALLEGRO)
    target_link_libraries(openttd PRIVATE ALLEGRO::ALLEGRO)
    target_compile_definitions(openttd PRIVATE WITH_ALLEGRO)
endif()

if(OPENTTD_SDL)
    target_compile_definitions(openttd PRIVATE WITH_SDL)
    target_link_libraries(openttd PRIVATE SDL)
endif()

if(OPENTTD_COCOA)
    target_compile_definitions(openttd PRIVATE WITH_COCOA)
    target_link_libraries(openttd PRIVATE COCOA)
endif()

if(OPENTTD_SSE)
    target_compile_definitions(openttd PRIVATE WITH_SSE)
endif()

if(OPENTTD_ICONV)
    target_compile_definitions(openttd PRIVATE WITH_ICONV)
    if(OPENTTD_ICONV_NON_CONST)
        target_compile_definitions(openttd PRIVATE HAVE_NON_CONST_ICONV)
    endif()
endif()

if(OPENTTD_PERSONAL_DIR)
    target_compile_definitions(openttd PRIVATE WITH_PERSONAL_DIR)
endif()

if(OPENTTD_XDG_BASEDIR)
    target_compile_definitions(openttd PRIVATE WITH_XDG_BASEDIR)
endif()

if(OPENTTD_UNISCRIBE)
    target_link_libraries(openttd PRIVATE UNISCRIBE::UNISCRIBE)
    target_compile_definitions(openttd PRIVATE WITH_UNISCRIBE)
endif()

if(OPENTTD_XAUDIO2)
    target_compile_definitions(openttd PRIVATE WITH_XAUDIO2)
endif()

# Add compiler definitions for OS support
if(UNIX)
    target_compile_definitions(openttd PRIVATE UNIX)
endif()

# Add third party libraries to link to.
target_link_libraries(openttd
    PRIVATE
    Squirrel
    SqStdLib
    MD5
    Threads::Threads
    )

#
# Adding explicit dependencies to generated source files
#
target_sources(openttd
    PRIVATE
    ${LANGUAGE_LNG_FILES}
    ${CMAKE_CURRENT_BINARY_DIR}/src/rev.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/src/table/settings.h
    ${CMAKE_CURRENT_BINARY_DIR}/src/table/strings.h
    )
target_sources(openttd PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/src/rev.cpp)

# TODO: Add the documentation subtree
# add_subdirectory(doc)
