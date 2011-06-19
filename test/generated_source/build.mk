EXECUTABLES = generated_source_test

generated_source_test_SOURCES := main.cc generated.cc

CXXFLAGS += -I$(GENERATED_SOURCE_DIR)

$(eval $(call add-dir,$(GENERATED_SOURCE_DIR)))

$(GENERATED_SOURCE_DIR)/generated.cc: $(SUBDIR)/make_generated.pl | $(GENERATED_SOURCE_DIR)
	$< -i $(SUBDIR)/generated.input -o $@ -m source

$(GENERATED_SOURCE_DIR)/generated.hh: $(SUBDIR)/make_generated.pl | $(GENERATED_SOURCE_DIR)
	$< -i $(SUBDIR)/generated.input -o $@ -m header

$(TMPDIR)/main.o: $(GENERATED_SOURCE_DIR)/generated.hh

