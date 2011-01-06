ifndef BS__SUBDIR_MK
BS__SUBDIR_MK=1

define subdir-include

$(eval include $(1)/build.mk)

$(foreach dso,$(DSOS), \
    $(eval fulldso = $(1)/$(dso)) \
    $(eval ALL_DSOS += $(fulldso)) \
    $(eval BUILD_DSO_$(fulldso) = $(BUILDDIR)/lib/$(dso).so) \
    $(eval SUBDIR_$(fulldso) = $(1)) \
    $(foreach v,$(PER_TARGET_VARIABLES), \
        $(eval $(fulldso)_$(v)=$($(dso)_$(v))) \
    ) \
)

endef

#include $(foreach s,$(SUBDIRS),$(s)/build.mk)
$(foreach s,$(SUBDIRS),$(eval $(call subdir-include,$(s))))

BUILD_DSOS = $(foreach d,$(ALL_DSOS),$(BUILD_DSO_$(d)))

$(foreach d,$(ALL_DSOS), \
    $(eval OBJECTS_$(d) = $(patsubst %.cc,$(TMPDIR)/$(SUBDIR_$(d))/%.o,$($(d)_SOURCES))))

endif
