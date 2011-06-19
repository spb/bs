EXECUTABLES = generated_source_test

generated_source_test_SOURCES := main.cc generated.cc

CXXFLAGS += -I$(GENERATED_SOURCE_DIR)

$(eval $(call add-dir,$(GENERATED_SOURCE_DIR)))

MKGEN := $(SUBDIR)/make_generated.pl

$(GENERATED_SOURCE_DIR)/generated.cc: $(SUBDIR)/generated.input $(MKGEN) | $(GENERATED_SOURCE_DIR)
	$(MKGEN) -i $< -o $@ -m source

$(GENERATED_SOURCE_DIR)/generated.hh: $(SUBDIR)/generated.input $(MKGEN) | $(GENERATED_SOURCE_DIR)
	$(MKGEN) -i $< -o $@ -m header

$(TMPDIR)/main.o: $(GENERATED_SOURCE_DIR)/generated.hh

