# Autodetect if GCC supports a certain compile flag.
#
# autodetect_gcc_compile_flag(COMPILE_FLAG OUTPUT)
#
function(autodetect_gcc_compile_flag COMPILE_FLAG OUTPUT)
    include(CheckCXXSourceCompiles)
    set(CMAKE_REQUIRED_FLAGS ${COMPILE_FLAG})

    check_cxx_source_compiles("
        int main() { return 0; }"
        ${OUTPUT})
endfunction()
