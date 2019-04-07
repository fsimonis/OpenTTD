macro(_autodetect_program FRIENDLY NAME EXECUTABLE)
    if (DEFINED ${NAME}_FOUND)
        return()
    endif (DEFINED ${NAME}_FOUND)

    message(STATUS "Detecting ${FRIENDLY}")
    find_program(${NAME}_EXECUTABLE ${EXECUTABLE})
    if (NOT ${NAME}_EXECUTABLE)
        message(STATUS "Detecting ${FRIENDLY} - not found")
        set(${NAME}_FOUND NO)
    else (NOT ${NAME}_EXECUTABLE)
        message(STATUS "Detecting ${FRIENDLY} - found")
        set(${NAME}_FOUND YES)
    endif (NOT ${NAME}_EXECUTABLE)

    # Make sure these values are cached properly
    set(${NAME}_FOUND "${${NAME}_FOUND}" CACHE INTERNAL "")
endmacro()

# Autodetect grfcodec and nforenum.
#
# autodetect_grfcodec()
#
function(autodetect_grfcodec)
    _autodetect_program(nforenum NFORENUM nforenum)
    _autodetect_program(grfcodec GRFCODEC grfcodec)
endfunction()
