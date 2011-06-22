DSOS = perlext

perlext_SOURCES = test.xs function.cpp

perlext_FILENAME = lib/Test.so

perlext_CXXFLAGS = $(shell perl -MExtUtils::Embed -e ccopts)

$(BUILDDIR)/lib/Test.so: $(BUILDDIR)/lib/Test.pm $(BUILDDIR)/bin/test.pl

# FIXME: replace when we have proper data file support
$(BUILDDIR)/bin/test.pl: $(SUBDIR)/test.pl
	cp $< $@

$(BUILDDIR)/lib/Test.pm: $(SUBDIR)/Test.pm
	cp $< $@
