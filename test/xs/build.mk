DSOS = perlext

perlext_SOURCES = test.xs function.cpp

perlext_FILENAME = lib/Test.$(BS_DSO_SUFFIX)

perlext_CXXFLAGS = $(shell perl -MExtUtils::Embed -e ccopts)
perlext_LDFLAGS  = $(shell perl -MExtUtils::Embed -e ldopts)

$(BUILDDIR)/lib/Test.$(BS_DSO_SUFFIX): $(BUILDDIR)/lib/Test.pm $(BUILDDIR)/bin/test.pl

# FIXME: replace when we have proper data file support
$(BUILDDIR)/bin/test.pl: $(SUBDIR)/test.pl
	cp $< $@

$(BUILDDIR)/lib/Test.pm: $(SUBDIR)/Test.pm
	cp $< $@
