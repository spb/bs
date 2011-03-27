ifndef BS_MK
BS_MK=1

default: all

ifndef BS_DIR
ifneq ($(MAKEFILE_LIST),)
BS_DIR := $(patsubst %/bs.mk,%,$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))
endif
endif

ifeq ($(BS_DIR),)
$(error Could not locate BS root directory -- try setting $$(BS_DIR))
endif

include $(BS_DIR)/init.mk
include $(BS_DIR)/functions.mk
include $(BS_DIR)/language-functions.mk
include $(BS_DIR)/depends.mk
include $(BS_DIR)/subdir.mk

include $(wildcard $(BS_DIR)/language/*.mk)

include $(BS_DIR)/objects.mk

all: $(BUILD_DSOS) $(BUILD_EXECUTABLES)

define dso-rule

$(BUILD_DSO_$(1)): $(OBJECTS_$(1)) | $(BUILDDIR)/lib
	g++ -shared -o$$@ $(call expand-target-variable,$(1),LDFLAGS) $(OBJECTS_$(1))

endef

define exec-rule

$(BUILD_EXEC_$(1)): $(OBJECTS_$(1)) | $(BUILDDIR)/bin
	g++ -o$$@ \
	    $(addprefix -L,$(dir $(sort $(BUILD_DSOS)))) \
	    $(call expand-target-variable,$(1),LDFLAGS) \
	    $(call expand-target-dependencies,$(1)) \
	    $(OBJECTS_$(1))

endef

$(foreach dsoname, $(ALL_DSOS), $(eval $(call dso-rule,$(dsoname))))
$(foreach execname, $(ALL_EXECS), $(eval $(call exec-rule,$(execname))))

$(DIRS):
	mkdir -p $@

endif
