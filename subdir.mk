ifndef BS__SUBDIR_MK
BS__SUBDIR_MK=1

# In this file resides most of the scary voodoo. Essentially, we include
# build.mk from each subdirectory in turn, doing appropriate reassignments to
# isolate its settings from those in any other subdirectory.

define subdir-include

$(eval $(call save-vars,$(SUBDIR_VARIABLES),subdir_$(1)))
$(foreach v,$(SUBDIR_VARIABLES),$(eval $(v)=))

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

$(foreach v,$(SUBDIR_VARIABLES), \
    $(eval $(1)_$(v)=$($(v))) \
)

$(eval $(call load-vars,subdir_$(1)))

endef

#include $(foreach s,$(SUBDIRS),$(s)/build.mk)
$(foreach s,$(SUBDIRS),$(eval $(call subdir-include,$(s))))

BUILD_DSOS = $(foreach d,$(ALL_DSOS),$(BUILD_DSO_$(d)))

$(foreach d,$(ALL_DSOS), \
    $(eval OBJECTS_$(d) = $(patsubst %.cc,$(TMPDIR)/$(SUBDIR_$(d))/%.o,$($(d)_SOURCES))))

endif
