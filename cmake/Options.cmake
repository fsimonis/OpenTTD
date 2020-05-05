# Set the options for the directories (personal, shared, global).
#
# set_directory_options()
#
function(set_directory_options)
    if (APPLE)
        set(DEFAULT_PERSONAL_DIR "Documents/OpenTTD")
        set(DEFAULT_SHARED_DIR "/Library/Application Support/OpenTTD")
        set(DEFAULT_GLOBAL_DIR "(not set)")
    elseif (WIN32)
        set(DEFAULT_PERSONAL_DIR "OpenTTD")
        set(DEFAULT_SHARED_DIR "(not set)")
        set(DEFAULT_GLOBAL_DIR "(not set)")
    elseif (UNIX)
        set(DEFAULT_PERSONAL_DIR ".openttd")
        set(DEFAULT_SHARED_DIR "(not set)")
        set(DEFAULT_GLOBAL_DIR "${CMAKE_INSTALL_PREFIX}/share/games/openttd")
    else ()
        message(FATAL_ERROR "Unknown OS found; please consider creating a Pull Request to add support for this OS.")
    endif ()

    if (NOT PERSONAL_DIR)
        set(PERSONAL_DIR "${DEFAULT_PERSONAL_DIR}" CACHE STRING "Personal directory")
        message(STATUS "Detecting Personal Data directory - ${PERSONAL_DIR}")
    endif (NOT PERSONAL_DIR)

    if (NOT SHARED_DIR)
        set(SHARED_DIR "${DEFAULT_SHARED_DIR}" CACHE STRING "Shared directory")
        message(STATUS "Detecting Shared Data directory - ${SHARED_DIR}")
    endif (NOT SHARED_DIR)

    if (NOT GLOBAL_DIR)
        set(GLOBAL_DIR "${DEFAULT_GLOBAL_DIR}" CACHE STRING "Global directory")
        message(STATUS "Detecting Global Data directory - ${GLOBAL_DIR}")
    endif (NOT GLOBAL_DIR)
endfunction()

# Set some generic options that influence what is being build.
#
# set_options()
#
function(set_options)
    if (UNIX AND NOT APPLE)
        set(DEFAULT_OPTION_INSTALL_FHS YES)
    else (UNIX AND NOT APPLE)
        set(DEFAULT_OPTION_INSTALL_FHS NO)
    endif (UNIX AND NOT APPLE)

    option(OPTION_DEDICATED "Build dedicated server only (no GUI)" NO)
    option(OPTION_INSTALL_FHS "Install with Filesstem Hierarchy Standard folders" ${DEFAULT_OPTION_INSTALL_FHS})
    option(OPTION_USE_ASSERTS "Use assertions; leave enabled for nightlies, betas, and RCs" YES)
    option(OPTION_USE_THREADS "Use threads" YES)
endfunction()

# Set option to enable the use of ccache.
#
# set_ccache_option()
#
function(set_ccache_option)
  option(OPTION_USE_CCACHE "Use ccache" OFF)
  if(OPTION_USE_CCACHE)
    find_program(CCACHE_COMMAND ccache)
    if(CCACHE_COMMAND)
      message(STATUS "ccache enabled - ${CCACHE_COMMAND}")
      set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_COMMAND}" CACHE FILEPATH "The compiler launcher for CXX.")
      set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_COMMAND}" CACHE FILEPATH "The compiler launcher for C.")
    else()
      message(FATAL_ERROR "ccache was not found.")
    endif()
  else()
    message(STATUS "ccache disabled")
  endif()
endfunction()

# Show the values of the generic options.
#
# show_options()
#
function(show_options)
    message(STATUS "Option Dedicated - ${OPTION_DEDICATED}")
    message(STATUS "Option Install FHS - ${OPTION_INSTALL_FHS}")
    message(STATUS "Option Use assert - ${OPTION_USE_ASSERTS}")
    message(STATUS "Option Use threads - ${OPTION_USE_THREADS}")
endfunction()

# Add the definitions for the options that are selected.
#
# add_definitions_based_on_options()
#
function(add_definitions_based_on_options)
    if (OPTION_DEDICATED)
        add_definitions(-DDEDICATED)
    endif (OPTION_DEDICATED)

    if (NOT OPTION_USE_THREADS)
        add_definitions(-DNO_THREADS)
    endif (NOT OPTION_USE_THREADS)

    if (OPTION_USE_ASSERTS)
        add_definitions(-DWITH_ASSERT)
    else (OPTION_USE_ASSERTS)
        add_definitions(-DNDEBUG)
    endif (OPTION_USE_ASSERTS)
endfunction()
