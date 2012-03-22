ifndef BS__INIT_MK
BS__INIT_MK=1

BUILDDIR ?= build
TMPROOT ?= intermediate

TARGET_VARIABLES = CXXFLAGS LDFLAGS SOURCES LIBRARIES CONTAINS SRCDIRS BINDIR LIBDIR
SUBDIR_VARIABLES = SUBDIRS DATADIR DATA
SUBDIR_VARIABLES += $(TARGET_VARIABLES)
SUBDIR_VARIABLES += $(addsuffix S,$(_BS_SUPPORTED_TARGETS))

DIRS =

# Default values for variables that can later be added to or overridden
CPPFLAGS = -I.

BINDIR = $(if $(PREFIX),$(PREFIX)/)bin
LIBDIR = $(if $(PREFIX),$(PREFIX)/)lib
TESTDIR ?= $(BINDIR)

endif
