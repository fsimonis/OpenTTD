# This module defines the following variables:
#
# DistCC_FOUND
#   True if distcc was found.
#
# DistCC_BIN
#   The full path to the distcc binary
#
# This module takes the following environment variables into account:
# DistCC_ROOT
#
# This module takes the following CMAKE variables into account:
# DistCC_ROOT

find_program(DistCC_BIN
    NAME distcc
    HINTS ENV DistCC_ROOT DistCC_ROOT
    )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DistCC
    REQUIRED_VARS DistCC_BIN)

mark_as_advanced(DistCC_BIN)
