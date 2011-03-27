ifndef BS__SUBDIR_MK
BS__SUBDIR_MK=1

# In this file resides most of the scary voodoo. Essentially, we include
# build.mk from each subdirectory in turn, doing appropriate reassignments to
# isolate its settings from those in any other subdirectory.
#
# Annoyingly, the use of eval on every line inside here is, I think, required
# to support recursive including (and hence SUBDIRS more than one level deep).
#
# Essentially, the first include must be processed completely before we can
# know how many other include statements will be needed, hence it must be
# eval-ed in here, and everything else then cascades -- we need to do the other
# processing of this subdir before doing anything to the next one, so that must
# be eval-ed immediately, etc.

define subdir-include

$(eval SUBDIR=$(1))
$(eval $(call save-vars,$(SUBDIR_VARIABLES),subdir_$(1)))
$(foreach v,$(SUBDIR_VARIABLES),$(eval $(v)=))

$(eval include $(1)/build.mk)

$(foreach dso,$(DSOS), \
    $(eval fulldso = $(1)/$(dso)) \
    $(eval ALL_DSOS += $(fulldso)) \
    $(eval BUILD_DSO_$(fulldso) = $(BUILDDIR)/lib/lib$(dso).so) \
    $(eval LIBRARY_NAME_$(fulldso) = $(dso)) \
    $(eval SUBDIR_$(fulldso) = $(1)) \
    $(foreach v,$(TARGET_VARIABLES), \
        $(eval $(fulldso)_$(v)=$($(dso)_$(v))) \
    ) \
)

$(foreach exec,$(EXECUTABLES), \
    $(eval fullexec = $(1)/$(exec)) \
    $(eval ALL_EXECS += $(fullexec)) \
    $(eval BUILD_EXEC_$(fullexec) = $(BUILDDIR)/bin/$(exec)) \
    $(eval SUBDIR_$(fullexec) = $(1)) \
    $(foreach v, $(TARGET_VARIABLES), \
        $(eval $(fullexec)_$(v)=$($(exec)_$(v))) \
    ) \
)

$(foreach v,$(SUBDIR_VARIABLES), \
    $(eval $(1)_$(v)=$($(v))) \
)

$(foreach v,$($(1)_SUBDIRS), \
    $(eval $(call subdir-include,$(1)/$(v))))

$(eval $(call load-vars,subdir_$(1)))

endef

#include $(foreach s,$(SUBDIRS),$(s)/build.mk)
$(foreach s,$(SUBDIRS),$(eval $(call subdir-include,$(s))))

BUILD_DSOS = $(foreach d,$(ALL_DSOS),$(BUILD_DSO_$(d)))
BUILD_EXECUTABLES = $(foreach e,$(ALL_EXECS),$(BUILD_EXEC_$(e)))

endif
