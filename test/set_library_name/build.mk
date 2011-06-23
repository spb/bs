DSOS = dso1 dso2
EXECUTABLES = test_libname

dso1_SOURCES = library.cpp
dso2_SOURCES = library2.cpp

# Test both setting the library name (foo -> libfoo.so) and the
# filename directly
dso1_LIBNAME = testlibname
dso2_FILENAME = lib/testfilename.so

test_libname_SOURCES = executable.cpp
test_libname_LIBRARIES = set_library_name/dso1 -ldl
