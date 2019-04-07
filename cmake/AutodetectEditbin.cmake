# Autodetect editbin. Only useful for MSVC.
#
# autodetect_editbin()
#
function(autodetect_editbin)
    if (DEFINED EDITBIN_FOUND)
        return()
    endif (DEFINED EDITBIN_FOUND)

    message(STATUS "Detecting editbin")

    get_filename_component(MSVC_COMPILE_DIRECTORY ${CMAKE_CXX_COMPILER} DIRECTORY)
    find_program(
        EDITBIN_EXECUTABLE editbin.exe
        HINTS ${MSVC_COMPILE_DIRECTORY}
    )

    if (NOT EDITBIN_EXECUTABLE)
        message(FATAL_ERROR "editbin is required for this platform; this should be shipped with MSVC!")
    endif (NOT EDITBIN_EXECUTABLE)

    message(STATUS "Detecting editbin - found")

    # Make sure these values are cached properly
    set(EDITBIN_FOUND YES CACHE INTERNAL "")
endfunction()
