add_library(OS2)
set_target_properties(OS2 PROPERTIES LINKER_LANGUAGE CXX)
target_sources(OS2
    PRIVATE
    getaddrinfo.c
    getaddrinfo.h
    getnameinfo.c
    getnameinfo.h
    )
target_include_directories(OS2
    PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}
    )
