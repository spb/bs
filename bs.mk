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

# This really should be a default
.DELETE_ON_ERROR:
.SECONDARY:

include $(BS_DIR)/init.mk
include $(BS_DIR)/functions.mk
include $(BS_DIR)/language-functions.mk
include $(BS_DIR)/depends.mk

include $(wildcard $(BS_DIR)/language/*.mk)
include $(wildcard $(BS_DIR)/targets/*.mk)

include $(BS_DIR)/subdir.mk
include $(BS_DIR)/objects.mk

all: $(ALL_BUILD_TARGETS)

$(foreach target,$(_BS_ALL_TARGETS), \
    $(eval $(call _BS_TARGET_RULE_$(_BS_TARGET_TYPE_$(target)),$(target))))

#$(foreach target,$(_BS_ALL_TARGETS), \
    $(info $(call _BS_TARGET_RULE_$(_BS_TARGET_TYPE_$(target)),$(target))))

$(DIRS):
	mkdir -p $@

endif
