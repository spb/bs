ifndef BS__INIT_MK
BS__INIT_MK=1

BUILDDIR ?= build
TMPROOT ?= intermediate

TARGET_VARIABLES = CXXFLAGS LDFLAGS SOURCES LIBRARIES SRCDIRS BINDIR LIBDIR
SUBDIR_VARIABLES = CXXFLAGS LDFLAGS DSOS EXECUTABLES SUBDIRS SRCDIRS BINDIR LIBDIR

DIRS =

# Default values for variables that can later be added to or overridden
CPPFLAGS = -I.

BINDIR = $(if $(PREFIX),$(PREFIX)/)bin
LIBDIR = $(if $(PREFIX),$(PREFIX)/)lib

endif
