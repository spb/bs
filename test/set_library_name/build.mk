DSOS = dso
EXECUTABLES = test_libname

dso_SOURCES = library.cpp
test_libname_SOURCES = executable.cpp

dso_LIBNAME = testlibname
test_libname_LIBRARIES = set_library_name/dso

# No executable -> library magic dependencies yet
$(BUILDDIR)/bin/test_libname: $(BUILDDIR)/lib/libtestlibname.so

