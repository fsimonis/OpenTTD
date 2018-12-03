# This module defines the following variables:
#
# CCACHE_FOUND
#   True if ccache was found.
#
# CCACHE_BIN
#   The full path to the ccache binary
#
# This module takes the following environment variables into account:
# CCACHE_ROOT
#
# This module takes the following CMAKE variables into account:
# CCACHE_ROOT

find_program(CCACHE_BIN
    NAME ccache
    HINTS ENV CCACHE_ROOT CCACHE_ROOT
    )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CCACHE
    REQUIRED_VARS CCACHE_BIN)

mark_as_advanced(CCACHE_BIN)
