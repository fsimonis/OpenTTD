cmake_minimum_required(VERSION 3.8)
project(openttd VERSION 1.7.2 LANGUAGES CXX)

# Also search the project cmake directory for modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

# Detect OS2
if (CMAKE_SYSTEM_NAME EQUAL "OS2")
    set(OS2 "yes")
endif()

cmake_host_system_information(RESULT HAS_SSE QUERY HAS_SSE)

find_package(PNG REQUIRED)
find_package(ZLIB REQUIRED)
find_package(LZO2 REQUIRED)
find_package(LibLZMA REQUIRED)
find_package(Freetype REQUIRED)
find_package(FontConfig REQUIRED)
# find_package(ICU REQUIRED)
find_package(Squirrel REQUIRED)

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


# Endian seems to be obsolete
#
# Add the endian_check as an empty target.
# add_executable(endian_check)
# 
# # Set the C++ Standard to C++11
# target_compile_features(endian_check
#     PRIVATE
#     cxx_std_11
#     )
# 
# # Add sources for endian_check
# target_sources(endian_check
#     PRIVATE
#     src/endian_check.cpp
#     )
# 
# # Add command to generate header endian_host.h
# add_custom_command(
#     OUTPUT src/endian_host.h
#     COMMAND endian_check > ${CMAKE_CURRENT_BINARY_DIR}/src/endian_host.h # TODO Make this redirect portable
#     MAIN_DEPENDENCY endian_check
#     COMMENT Generating endian_host.h
#     )
# 
# # Add command to generate header endian_target.h
# add_custom_command(
#     OUTPUT src/endian_target.h
#     COMMAND endian_check AUTO > ${CMAKE_CURRENT_BINARY_DIR}/src/endian_target.h # TODO Make this redirect portable
#     MAIN_DEPENDENCY endian_check
#     COMMENT Generating endian_target.h
#     )

# TODO Remove depend as it is not needed anymore

# TODO String Generation
# $(LANG_OBJS_DIR)/$(STRGEN):
# 	$(MAKE) -C $(LANG_OBJS_DIR) $(STRGEN)
# 
# $(LANG_OBJS_DIR)/table/strings.h: $(LANG_DIR)/english.txt $(LANG_OBJS_DIR)/$(STRGEN)
# 	$(MAKE) -C $(LANG_OBJS_DIR) table/strings.h

# TODO Version configuration
# Targets: VERSIONS MODIFIED REV REV_NR
# o/r/Makefile

#
# Configure version files
#

# Construct variables needed to configure src/rev.cpp.in

# From findversion.sh
# REV
#     a string describing what version of the code the current checkout is
#     based on. The exact format of this string depends on the version
#     control system in use, but it tries to identify the revision used as
#     close as possible (using the svn revision number or hg/git hash).
#     This also includes an indication of whether the checkout was
#     modified and which branch was checked out. This value is not
#     guaranteed to be sortable, but is mainly meant for identifying the
#     revision and user display.
# 
#     If no revision identifier could be found, this is left empty.
# REV_NR
#     the revision number of the svn revision this checkout is based on.
#     This can be used to determine which functionality is present in this
#     checkout. For trunk svn checkouts and hg/git branches based upon it,
#     this number should be accurate. For svn branch checkouts, this
#     number is mostly meaningless, at least when comparing with the
#     REV_NR from other branches or trunk.
# 
#     This number should be sortable. Within a given branch or trunk, a
#     higher number means a newer version. However, when using git or hg,
#     this number will not increase on new commits.
# 
#     If no revision number could be found, this is left empty.
# MODIFIED
#     Whether (the src directory of) this checkout is modified or not. A
#     value of 0 means not modified, a value of 2 means it was modified.
#     Modification is determined in relation to the commit identified by
#     REV, so not in relation to the svn revision identified by REV_NR.
# 
#     A value of 1 means that the modified status is unknown, because this
#     is not an svn/git/hg checkout for example.
# 
# CLEAN_REV
#     the same as REV but without branch name


# Construct OPENTTD_DATE
string(TIMESTAMP OPENTTD_DATE "%d.%m.%y")

find_package(Subversion)
find_package(Git)
find_package(Hg)
if()
else()
endif()

#defaults
# MODIFIED="1"
# BRANCH=""
# REV=""
# REV_NR=""

# if MODIFIED then set REV={REV}M
# set CLEAN_REV=REV
# if BRANCH then set REV={REV}-BRANCH


set(OPENTTD_MODIFIED "")
set(OPENTTD_REVISION "")
set(OPENTTD_VERSION "")

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

#
# The OpenTTD executable
#

# Add openttd as en empty target.
# See src/CMakeLists.txt for the sources.
add_executable(openttd)

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
    src
    # Include configured files from the build-tree
    ${CMAKE_CURRENT_BINARY_DIR}/src
    )

# Add libraries to link to.
target_link_libraries(openttd
    PRIVATE
    png
    zlib
    LZO2::LZO2
    lzma
    freetype
    fontconfig
    icu
    sdl
    allegro
    )

# Explicitly add the dependency to the version configuration.
# add_dependencies(openttd configure_version)


# Add the sources subtree
add_subdirectory(src)

target_sources(openttd
    PRIVATE
    src/table/strings.h
    ${LANGUAGE_LNG_FILES}
    )

# Add the objects subtree
# add_subdirectory(objs)

# TODO: Add the documentation subtree
# add_subdirectory(doc)
