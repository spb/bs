ifndef BS__PLATFORM_MK
BS__PLATFORM_MK=1

_RAW_PLATFORM=$(shell uname)

ifeq ($(_RAW_PLATFORM), Linux)
BS_PLATFORM=linux
else
ifeq ($(filter-out CYGWIN_NT%,$(_RAW_PLATFORM)),)
BS_PLATFORM=cygwin
endif
endif

ifeq ($(BS_PLATFORM),)
$(error couldn't determine platform.) #')
endif

include $(BS_DIR)/platforms/$(BS_PLATFORM).mk

endif
