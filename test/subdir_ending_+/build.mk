# This one doesn't do anything interesting in itself, except to make sure that
#  things work as expected when there's a directory (or a target) ending in +
#  (see commit cadc3a31)

EXECUTABLES = executable_ending_+

executable_ending_+_SOURCES = test_executable.cc

