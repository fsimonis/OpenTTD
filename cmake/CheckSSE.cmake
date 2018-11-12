#
# Author: Frédéric Simonis
#
# This file contains the function check_sse, which tries to compile a test program
# using the current compiler configuration.
# It raises an error if support for sse is not detected.
#

function(check_sse)
    file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/check_sse)
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/check_sse/test.cpp "
#include <nmmintrin.h> // SSE 4.2
#include <smmintrin.h> // SSE 4.1
#include <tmmintrin.h> // SSSE 3
#include <pmmintrin.h> // SSE 3
#include <emmintrin.h> // SSE 2
#include <xmmintrin.h> // SSE
int main(int argc, char*argv[]) {
    __m128 a = _mm_set_ps1(1.234123f);
    __m128d b1 = _mm_set_pd1 (12.4123);
    __m128d b2 = _mm_set_pd1 (2.23213);
    __m128d r = _mm_addsub_pd (b1, b2);
    a = _mm_abs_epi32 (a);
    r = _mm_ceil_pd (r);
    __m64 b;
    unsigned int i = _mm_crc32_u32 (21u, 1u);
    int j = _mm_test_all_ones(r);
    return j + i;
}

")
        try_compile(
            SSE_CONFIGURED
            ${CMAKE_CURRENT_BINARY_DIR}/check_sse
            SOURCES ${CMAKE_CURRENT_BINARY_DIR}/check_sse/test.cpp)
        if(NOT SSE_CONFIGURED)
            message(FATAL_ERROR "Your compiler is not configured to compile sse instructions. Check your compiler flags for either \"-march=native\" or explicit flags such as \"-msse4.1\".")
        endif()
endfunction(check_sse)
