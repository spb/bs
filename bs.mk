ifndef BS_MK
BS_MK=1

default: all

include $(BS_DIR)/init.mk
include $(BS_DIR)/functions.mk
include $(BS_DIR)/subdir.mk

all: $(BUILD_DSOS)

define dso-rule

$(call add-dir, $(TMPDIR)/$(SUBDIR_$(1)))

$(OBJECTS_$(1)): $(TMPDIR)/$(SUBDIR_$(1))/%.o: $(SUBDIR_$(1))/%.cc | $(TMPDIR)/$(SUBDIR_$(1))
	$(CXX) -c -fPIC -o$$@ $(CXXFLAGS) $($(1)_CXXFLAGS) $($(SUBDIR_$(1))_CXXFLAGS) $$<

$(BUILD_DSO_$(1)): $(OBJECTS_$(1)) | $(BUILDDIR)/lib
	g++ -shared -o$$@ $($(1)_LDFLAGS) $(OBJECTS_$(1))

endef

$(foreach dsoname, $(ALL_DSOS), $(eval $(call dso-rule,$(dsoname))))

$(DIRS):
	mkdir -p $@

endif
